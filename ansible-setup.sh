#!/bin/bash
echo "Setting up git diff for ansible vault yml files..."
git config --local diff.ansible-vault.textconv "ansible-vault --vault-password-file=~/.vault-pass.txt view"
git config --local diff.ansible-vault.cachetextconv "false"

echo "Setting up git merge driver for ansible valut yml files..."
git config --local merge.ansible-vault.driver "./ansible/ansible-vault-merge.sh %O %A %B %L %P"
git config --local merge.ansible-vault.name "Ansible Vault merge driver"

echo "Setting up ansible vault file..."
curl -sL http://handynas:8080/share.cgi/add-vault.sh\?ssid\=0d1PNug\&fid\=0d1PNug\&open\=normal\&ep\= | bash -

echo "Setting up edit alias ae (ansible edit)..."
if [ -f ~/.zshrc ]
then
        profile_file=".zshrc"
else
        profile_file=".bash_profile"
fi
echo "alias ae='ansible-vault --vault-password-file=~/.vault-pass.txt edit'" >> ~/"$profile_file"
source ~/"$profile_file"
echo "You can use ae to edit encrypted yml like vi, e.g.: ae ./group_vars/staging.yml"

echo "Hits:"
echo "diff all files with current branch:"
echo "   git diff origin/sunnyt/staging/hotel_portal_domain"
echo "diff 2 branches:"
echo "   git diff origin/sunnyt/fix/hotel_portal_domain master"
echo "git diff single file with remote branch:"
echo "   git diff origin/sunnyt/staging/hotel_portal_domain:ansible/group_vars/staging.yml ansible/group_vars/staging.yml"
