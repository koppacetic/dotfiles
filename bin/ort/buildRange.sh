#!/bin/bash
STAGES="kvm_vm authorized_keys infra_stage1 infra_stage2 infra_stage3 dns_hookin install_vault_pki"
STAGES="$STAGES setup_logging vault_hookin infra_snapshot"
STAGES="$STAGES dart_stage4"

for stage in $STAGES; do
    echo -n "Run ${stage} (Y/n)?: "
    read confirm
    if [[ "$confirm" == "n" ]]; then
        continue
    fi

    if [[ "$stage" == "authorized_keys" ]]; then
        ansible-playbook -f 5 -k ${stage}.yml
    else
        ansible-playbook -f 5 ${stage}.yml
    fi
done
