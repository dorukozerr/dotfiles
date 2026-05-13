typeset -ga ZVM_DISABLED_KEYS=("viins ^R" "vicmd ^R")

functions[_zvm_bindkey_orig]=$functions[zvm_bindkey]
zvm_bindkey() {
  (( ${ZVM_DISABLED_KEYS[(Ie)$1 $2]} )) && return
  _zvm_bindkey_orig "$@"
}
