#!/bin/bash
#模拟的场景，如果是在主分支的时候作出修改，那么此时子分支视图下的文件内容会不会改变,如新增文件，或者改动提交后的文件。
#当前是master分支，然后我们先测试添加文件。然后切换到子分支。
#此时文件是存在的，那就是说文件的修改是生效在所有的分支？？？？
#那我们来修改子分支的内容看看父分支的内容是否修改，此时主分支也改变了，说明父子分支是公用一个文件系统。
#那么为什么会产生在有的分支下有对应的文件，有的分支下没有对应的文件呢？比如我的书籍下的index.html
#未被追踪的文件会存在于所有的分支，一旦作出修改提交后就独属于某个分支。

#我们要模拟，遍历所有符合条件的文件夹，然后逐次的复制并提交文件。
#遍历符合条件的文件夹
tmp=$(ls -l ./ |awk '/^d/ {print $NF}')
for path in $tmp
do
    cd $path
	gitbook build
    cd ../
done
#切换到主分支
git checkout master
#将所有的添加到我们想要的地方
git add .
git commit -m $1
git push -u origin master
git checkout pages
git add .
dir=$(ls -l ./ |awk '/^d/ {print $NF}')
for path in $dir
do
    cd $path
	if [ -d "_book" ]; then
		cp -r _book/* .
	fi
    cd ../
done
git add .
git commit -m $1
git push -u origin pages
git checkout master