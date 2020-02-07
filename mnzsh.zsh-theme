# vim:ft=zsh ts=2 sw=2 sts=2

# 用户名@机器名
prompt_context() {
    echo -n "%{$fg_bold[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m "
}

# 上次执行状态
prompt_status() {
    if [ $RETVAL -eq 0 ]; then
        echo -n "\n%F{cyan}❯❯❯%{$reset_color%} "
    else
        echo -n "\n%F{red}\u2718\u2718\u2718%{$reset_color%} "
    fi
}

# 相对~的路径
prompt_dir() {
  echo -n "%{$fg_bold[cyan]%}%~%{$reset_color%} "
}

# 当前时间
prompt_time() {
    echo -n "%{$fg_bold[cyan]%}[%*]%{$reset_color%} "
}

# git信息
prompt_git() {
    (( $+commands[git] )) || return
    if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
        return
    fi
    local ref dirty mode repo_path

    if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        repo_path=$(git rev-par se --git-dir 2>/dev/null)
        dirty=$(parse_git_dirty)
        ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"

        if [[ -e "${repo_path}/BISECT_LOG" ]]; then
            mode=" <B>"
        elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
            mode=" >M<"
        elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
            mode=" >R>"
        fi
        echo -n "on %{$fg[blue]%}\uE0A0 ${ref/refs\/heads\//}${vcs_info_msg_0_%% }${mode}%{$reset_color%}"

        if [[ $dirty ]]; then
            echo -n "%{$fg_bold[red]%}(dirty)%{$reset_color%}"
        fi
    fi
}

# 结合所有部件
build_prompt() {
    RETVAL=$?
    prompt_time
    prompt_context
    prompt_dir
    prompt_git
    prompt_status
}

PROMPT='%{%f%b%k%}$(build_prompt)'
