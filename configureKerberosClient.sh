#!/bin/bash
echo "==================================================================================="
echo "==== Kerberos Client =============================================================="
echo "==================================================================================="
KADMIN_PRINCIPAL_FULL=$KADMIN_PRINCIPAL@$REALM

echo "REALM: $REALM"
echo "KADMIN_PRINCIPAL_FULL: $KADMIN_PRINCIPAL_FULL"
echo "KADMIN_PASSWORD: $KADMIN_PASSWORD"
echo ""

function kadminCommand {
    kadmin -p $KADMIN_PRINCIPAL_FULL -w $KADMIN_PASSWORD -q "$1"
}

echo "==================================================================================="
echo "==== /etc/krb5.conf ==============================================================="
echo "==================================================================================="
tee /etc/krb5.conf <<EOF
[libdefaults]
    default_realm = $REALM
    dns_canonicalize_hostname = false
    dns_lookup_realm = false
    dns_lookup_kdc = false

[realms]
    $REALM = {
        kdc = ${KDC_HOST}
        admin_server = ${KDC_HOST}
    }
EOF
echo ""

echo "==================================================================================="
echo "==== Testing ======================================================================"
echo "==================================================================================="
until kadminCommand "list_principals $KADMIN_PRINCIPAL_FULL"; do
  >&2 echo "KDC is unavailable - sleeping 1 sec"
  sleep 1
done
echo "KDC and Kadmin are operational"
echo ""


echo "==================================================================================="
echo "==== Add divolte principals ==========================================="
echo "==================================================================================="
echo "Add divolte user"
kadminCommand "addprinc -pw divolte divolte/$(hostname -f)@${REALM}"
echo "Create divolte keytab"
kadminCommand "xst -k /divolte.keytab divolte/$(hostname -f)"
exit 0
