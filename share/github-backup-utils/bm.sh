#!/bin/bash
# bm.sh: benchmarking Bash code blocks
#
# Example:
#   bm_start "wget request"
#   wget --quiet https://www.google.com
#   bm_end "wget request"
#
# Sample output:
#   $ bash test.sh
#   'wget request' took: 2s

bm_desc_to_varname(){
 echo "__bm$(echo $@ | tr -cd '[[:alnum:]]')"
}

bm_start()
{
  eval "$(bm_desc_to_varname $@)_start=$(date +%s)"
}

bm_end() {
  local tend=$(date +%s)
  local tstart=$(eval "echo \$$(bm_desc_to_varname $@)_start")

  local tmpbench=
  if [ -n "$GHE_RESTORE_SNAPSHOT_PATH" ]
    tmpbench=$GHE_RESTORE_SNAPSHOT_PATH/.benchmark.tmp
  else
    tmpbench=$GHE_SNAPSHOT_DIR/.benchmark.tmp
  fi

  if [ ! -f $tmpbench ]; then
    echo "$(date +%s)" > $tmpbench
  fi

  echo "'$1' took: $(($tend - $tstart))s" >> $tmpbench
}
