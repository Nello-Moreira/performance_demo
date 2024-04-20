#! /bin/bash

# This is a helper CLI to make it easier to run docker commands for this project

usage() {
  cat << EOF

________________________________________________________________

This tool aims to make it easier to run docker commands for this project.

  Usage:
      $0 <command>

  Commands:
      build, run, kill, stats
________________________________________________________________


EOF
}

search_in_flags(){
  for flag in $flags; do
    if [[ "$flag" == "$1" ]]; then
      return 0
    fi
  done
  return 1
}

build(){
  if search_in_flags "--help"; then
    print_build_help
    return 0
  fi
  base_docker_command+=" build"
  eval $base_docker_command
}
print_build_help() {
  cat << EOF

*** BUILD command ***
________________________________________________________________

This is the command to build the docker infrastructure defined in the compose file.

________________________________________________________________


EOF
}


run(){
  if search_in_flags "--help"; then
    print_run_help
    return 0
  fi
  base_docker_command+=" up --remove-orphans -d"
  eval $base_docker_command
}
print_run_help() {
  cat << EOF

*** RUN command ***
________________________________________________________________

This is the command to run the docker infrastructure defined in the compose files.

________________________________________________________________


EOF
}


kill_containers(){
  if search_in_flags "--help"; then
    print_kill_help
    return 0
  fi
  base_docker_command+=" down --remove-orphans"
  eval $base_docker_command
}
print_kill_help() {
  cat << EOF

*** KILL command ***
________________________________________________________________

This is the command to kill the containers that are built

________________________________________________________________


EOF
}


stats(){
  if search_in_flags "--help"; then
    print_stats_help
    return 0
  fi
  container_names=$($base_docker_command ps -q)
  # Check if any containers are running
  if [[ -n "$container_names" ]]; then
    docker stats $container_names
  else
    echo "No containers managed by the specified Docker Compose file are currently running."
  fi
}
print_stats_help() {
  cat << EOF

*** STATS command ***
________________________________________________________________

This command shows the statistics for running the running containers

________________________________________________________________


EOF
}


execute_command() {
  case $command in
    --help)
      usage
      exit 0
      ;;
    build)
      build
      exit 0
      ;;
    run)
      run
      exit 0
      ;;
    kill)
      kill_containers
      exit 0
      ;;
    stats)
      stats
      exit 0
      ;;
    *)
      echo "Unkown command: $command"
      exit 1
      ;;
  esac
}


command=$1
flags=${@:2}

base_docker_command="docker-compose -f ./docker/docker-compose.yaml --project-name performance_demo"

execute_command
