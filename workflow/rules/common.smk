#!/usr/bin/env python3

import os
from functools import cache
from snakemake.logging import logger


@cache
def get_container(container_name):
    containers = config["containers"]
    if container_name not in containers:
        raise ValueError(f"Container {container_name} not found in config.")
    my_container = containers[container_name]
    return (
        f"{my_container['prefix']}://"
        f"{my_container['url']}:"
        f"{my_container['tag']}"
    )


configfile: "config/config.yaml"
