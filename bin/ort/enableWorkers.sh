#!/bin/bash
systemctl enable cleanup_router_worker@{1..10}
systemctl enable git_cleanup_worker@{1..10}
systemctl enable git_worker@{1..10}
systemctl enable hal_worker@{1..10}
systemctl enable provision_begin_worker@{1..10}
systemctl enable provision_cert_worker@{1..10}
systemctl enable provision_cleanup_worker@{1..10}
systemctl enable provision_ip_worker@{1..5}
systemctl enable provision_kvm_worker@{1..5}
systemctl enable results_worker@{1..10}
systemctl enable solve_cleanup_worker@{1..5}
systemctl enable solve_worker@1
systemctl enable start_worker@{1..10}
systemctl enable test_worker@{1..10}
