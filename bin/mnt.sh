#!/bin/sh

case "$1" in

	"apple" )
		sshfs cysh@apple:/home/cysh /home/cysh/cyvil/apple;;
	"elephant" )
		sshfs cysh@elephant:/home/cysh /home/cysh/cyvil/elephant;;
	"dingo" )
		sshfs cysh@dingo:/home/cysh /home/cysh/cyvil/dingo;; 
	"banana" )
		sshfs cysh@banana:/home/cysh /home/cysh/cyvil/banana;;
	"maruta" )
		sshfs cysh@maruta:/home/cysh /home/cysh/cyvil/maruta;;
	"all" )
		sshfs cysh@elephant:/home/cysh /home/cysh/cyvil/elephant
		sshfs cysh@apple:/home/cysh /home/cysh/cyvil/apple
		sshfs cysh@dingo:/home/cysh /home/cysh/cyvil/dingo
		sshfs cysh@banana:/home/cysh /home/cysh/cyvil/banana
		sshfs cysh@maruta:/home/cysh /home/cysh/cyvil/maruta
		;;

	* )
		echo "don't have such a sever" $1
esac


