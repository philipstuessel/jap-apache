source ~/.zshrc
name="japache"
folder="${JAP_FOLDER}plugins/packages/${name}/"
folder_config="${folder}config/"
fetch2 $folder https://raw.githubusercontent.com/philipstuessel/japache/main/japache.zsh
fetch2 $folder_config https://raw.githubusercontent.com/philipstuessel/japache/main/config/japache.config.json
echo "--japache is installed--"