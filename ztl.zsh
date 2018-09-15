ANSIFILTER=''

if which ansifilter > /dev/null 2>&1; then
  ANSIFILTER='ansifilter'
elif which ~/.ztl/ansifilter > /dev/null 2>&1; then
  ANSIFILTER='~/.ztl/ansifilter'
else
  while true; do
    echo "ansifilter not found. Do you want to install ansifilter?(y/n)"
    read answer
    case $answer in
      y)
        PWD=`pwd`
        mkdir ~/.ztl
        curl http://www.andre-simon.de/zip/ansifilter-2.1.tar.bz --output /tmp/ansifilter-2.1.tar.bz2
        tar -jxvf /tmp/ansifilter-2.1.tar.bz2 -C /tmp/
        cd /tmp/ansifilter-2.1
        make
        mv src/ansifilter ~/.ztl/ansifilter
        rm -rf /tmp/ansifilter-2.1*
        ANSIFILTER='~/.ztl/ansifilter'
        cd ${PWD}
        ;;
      n)
        echo "Bye."
        exit 1
        ;;
      *)
        echo "Please type the y or n"
        ;;
    esac
  done
fi

CMD=${@}

if [ ${CMD} == "ssh" ]; then
  CMD+=" -o ConnectTimeout=5"
fi

if [[ $TERM = screen ]] || [[ $TERM = screen-256color ]] ; then
  local LOGDIR=$HOME/Documents/term_logs
  local LOGFILE=$(date +${2}_%Y-%m-%d_%H-%M-%S.log)
  local FILECOUNT=0
  local MAXFILECOUNT=200
  # 本スクリプト起動時に自動で$MAXFILECOUNTのファイル数以上ログファイルあれば消す
  for file in `\find "$LOGDIR" -maxdepth 1 -type f -name "*.log" | sort --reverse`; do
    FILECOUNT=`expr $FILECOUNT + 1`
    if [ $FILECOUNT -ge $MAXFILECOUNT ]; then
      rm -f $file
    fi
  done
  [ ! -d $LOGDIR ] && mkdir -p $LOGDIR
  tmux  set-option default-terminal "screen" \; \
  pipe-pane        "cat - | ${ANSIFILTER} | ./stamp.zsh >> $LOGDIR/$LOGFILE" \; \
  display-message  "💾Started logging to $LOGDIR/$LOGFILE"
  ${CMD}
  tmux pipe-pane\; display-message  "🔔End logging to $LOGDIR/$LOGFILE"
fi
