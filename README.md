# Overview

**Title:** guessinggame 
**Category:** Crypto  
**Flag:** libctf{ecb_mode_blocks_are_independent}  
**Difficulty:** easy to moderate  

# Usage

The following will pull the latest 'elttam/ctf-guessinggame' image from DockerHub, run a new container named 'libctfso-guessinggame', and publish the vulnerable service on port 80:

```sh
docker run --rm \
  --publish 80:80 \
  --name libctfso-guessinggame \
  elttam/ctf-guessinggame:latest
```

# Build (Optional)

If you prefer to build the 'elttam/ctf-guessinggame' image yourself you can do so first with:

```sh
docker build ${PWD} \
  --tag elttam/ctf-guessinggame:latest
```
