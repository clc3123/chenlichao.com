---
layout: post
title: apache-benchmark
description: apache-benchmark
---

$ ab -n 3 -c 3 127.0.0.1:9000/ | grep "Time taken"
