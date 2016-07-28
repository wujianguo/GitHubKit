#!/usr/bin/env bash

cd `dirname $0`
sed -i "s/1234567890/$ClientID/" GitHubApp/AppDelegate.swift
