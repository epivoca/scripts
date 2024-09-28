set -u

deploy_server=$1
ssh_port=$2
deploy_path=$3

echo "Deploying app to '$deploy_server' through ssh port '$ssh_port' to directory '$deploy_path'"

# list all the dirs you're aiming to deploy here
source_dirs=(./configs ./src)

for item in ${source_dirs[*]}; do
    rsync -v -r  --exclude '.git' --exclude 'venv' --exclude 'build' --exclude 'tests' --exclude '.DS_Store' --exclude '__pycache__' -e "ssh -p $ssh_port" $item $deploy_server:$deploy_path --delete
done

# list all the files you're aiming to deploy here
source_files=(convert_models.sh convert_models_multi_gpu.sh docker-compose.yml Dockerfile)
for file in ${source_files[*]}; do
  rsync -v -p -e "ssh -p $ssh_port" "$file" "$deploy_server":"$deploy_path"
done
