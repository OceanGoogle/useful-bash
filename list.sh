#!/usr/bin/env bash


hidden_shw=no
find_type=file
proc_type=
show_file="yes"
show_dir="yes"
chg_dir="no"
symb_link="no"
debug_on='no'
ori_dir=$PWD



str2array () { #  $1:V:xx string  $2: R:return array 
   local -n r_v="$2"
   
   ival="$1" ;
   for (( i=0; i<${#ival}; i++ )); do
    ch="${ival:i:1}"
    r_v+=("$ch") 
   done
}

parse_inp () { # V:$1: arguments value (string)   
    
    local args=()
    str2array "$1" args 

    for (( i=0; i<${#args[@]}; i++ )); do
         case  "${args[i]}" in
         h* | 'Help') 
            proc_type="help"
         ;;
         D*)
            show_dir="only"
         ;;
         d*)
            show_dir="yes"
         ;;
         F*)
            show_file="only"
         ;;
         f*)
            show_file="yes"
         ;;
         a* )
            hidden_shw="yes"
         ;;
         A* )
            hidden_shw="only"
         ;;
         l* | L*)
            symb_link="only" # only or no 
         ;;
         c* | C*)
            chg_dir="yes"
         ;;
         s* | debug*)
           debug_on='yes'
         ;;
         esac
    done
}

shw_ops () {
   [ "$debug_on" != yes ] && return 0

   echo '####################'
   echo hidden_shw=$hidden_shw
   echo find_type=$find_type
   echo proc_type=$proc_type
   echo show_file=$show_file
   echo show_dir=$show_dir
   echo chg_dir=$chg_dir
   echo symb_link=$symb_link
   
   echo '##############'
}

show_help () {
   cat <<"EOF"
   -h --help : show help
   -d --dir  : list dirs only
   -f --file : list files only
   -a --hide : show hidden (default: off)
   -A --hideOnly : show hidden only
   -l --symb : symblic link only
   -c        : change dir (follow dir name)
   -s --debug: debug info
EOF
}

filelist () # R:$1
{
local -n file_l=$1
local tmp

    tmp=$(shopt -p nullglob dotglob) # no .. & .

    shopt -s nullglob dotglob
    file_l=(*)                 # 

    eval "$tmp"
}

shw_name () # $1:V file or dir name
{
   if [ -d "$1" ] ; then 
         printf "%s/" "$1"  
   else 
         printf "%s" "$1"  
   fi   
   
   [ -L "$1" ] && printf "     -> %s" "$(readlink "$1")"    
}

#################################### main #####################################
args=()
args=("$@")


if [ ${#args[@]} -ne 0  ];  then # parse arguments
  for i in "${args[@]}" ; do
      case "$i" in
         -*) 
            i="${i#-}"   # remove '-'  
            [ -n "$i" ] && parse_inp "$i"
         ;;

         *) # directory assignment
            [ $chg_dir = yes ] && { echo 'set new target directory'; target_dir="$i";}
         ;;
      esac 
  done
  [ $show_dir = only ] && show_file=no
  [ $show_file = only ] && show_dir=no
else       # no arguments 
   hidden_shw=no
   find_type=file
   proc_type=
   show_file="yes"
   show_dir="no"
   chg_dir="no"
fi

# process loop

shw_ops 

[ "$proc_type" = help ] && { show_help ; exit 0;}  # help menu

# whether to chage dir?
if [ "$chg_dir" = "yes" ] ; then
   if [ ! -d "$target_dir" ] || [ ! -e "$target_dir" ] ; then
         echo target dir not exist; exit 1;
   else 
         ori_dir=$PWD
         cd "$target_dir" 
   fi 
fi

#
f_name=();
filelist  f_name # 


if [ "$symb_link" = only ] ; then  #-------- symblic links only
   for name in "${f_name[@]}";  do
      ! [ -L "$name" ] && continue
      case "$hidden_shw" in
         yes) echo $(shw_name "$name") ;; # all
         no) ! [[ "$name" = .* ]] && echo $(shw_name "$name") ;; # no hidden only
         only) [[ "$name" = .* ]] && echo $(shw_name "$name") ;; # only hidden
      esac
   done

elif ! [ "$show_dir" = "no" ] && [ "$show_file" = "no" ]; then   #--------- only diretory
   for name in "${f_name[@]}";  do
      
      ! [ -d "$name" ] && continue; 

      case "$hidden_shw" in
         yes) [ -e "$name" ] &&  echo $(shw_name "$name") ;; # all 
         no) ! [[ "$name" = .* ]] && echo $(shw_name "$name") ;; # no hidden only
         only) [[ "$name" = .* ]] && echo $(shw_name "$name") ;; # only hidden 
      esac
   done

elif [ "$show_dir" = "no" ] && ! [ "$show_file" = "no" ]; then   #---------- only files
   for name in "${f_name[@]}";  do
      
      ! [ -f "$name" ] && continue;

      case "$hidden_shw" in
         yes) [ -e "$name" ] &&  echo $(shw_name "$name") ;; # all 
         no) ! [[ "$name" = .* ]] && echo $(shw_name "$name") ;; # no hidden only
         only) [[ "$name" = .* ]] && echo $(shw_name "$name") ;; # only hidden 
      esac
   done

elif ! [ "$show_dir" = "no" ] && ! [ "$show_file" = "no" ]; then  #---------- both dirs & files
   for name in "${f_name[@]}";  do
      
      case "$hidden_shw" in
         yes) [ -e "$name" ] &&  echo $(shw_name "$name") ;; # all 
         no) ! [[ "$name" = .* ]] && echo $(shw_name "$name") ;; # no hidden only
         only) [[ "$name" = .* ]] && echo $(shw_name "$name") ;; # only hidden 
      esac
   done
fi

cd "$ori_dir"

