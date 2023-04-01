# xshell session 转 mobaxterm脚本

# 目录地址
dir='d:/Users/swx1160681/Desktop/2303/Sessions/beta'
parentDir=''
# 文件夹的图片样式
declare -i imgNum=42
declare -i J=0
command1="ls -l \"\$1\"|awk '{\$1=\$2=\$3=\$4=\$5=\$6=\$7=\$8=\"\"; print \$0}'|sed '1d;s/^\s\+//g;s/\s/??/g'"
#command2="echo \"\$fileOrDir\" | sed 's:??: :g';s:/\?::g"
command2="echo \"\$fileOrDir\" | sed 's:??: :g'"
#imgNum=42
#J=0

#echo `ls -l $dir | awk '{print $9}'`

# 解析.xsh文件
parseXshFile() {
	declare -i index=0
	local parentDirPath=$2
	local parentDirOrFile=$3
	echo "\$1=$1"
	echo "\$2=$parentDirPath"
	echo "\$3=$3"
	echo "ImgNum=$imgNum"
	if [ -d "$1" ]; then
		#echo "Dir=$1;"
		# 优先处理文件
		for fileOrDir in `eval $command1`
		do
			local evalCommand2="`eval $command2`"
			evalCommand2=${evalCommand2%%'/'*}
			echo "====$1/$evalCommand2"
			if [ -f "$1/$evalCommand2" ]; then
				echo "===================="
				parseXshFile "$1/$evalCommand2" "$1" "$evalCommand2"
			fi
		done
		# 自减
		let "imgNum=(--imgNum)"
		# 再处理目录
		for fileOrDir in `eval $command1`
		do
			local evalCommand2="`eval $command2`"
			evalCommand2=${evalCommand2%%'/'*}
			if [ -d "$1/$evalCommand2" ]; then
				#let "index=(++index)"
				let "J=(++J)"
				# 处理头
				echo -e "\n" >> $dir/export.txt
				echo "[Bookmarks_$J]" >> $dir/export.txt
				echo "SubRep="$3\\$evalCommand2"" >> $dir/export.txt
				echo "ImgNum=$4" >> $dir/export.txt
				#parseXshFile "$1/$evalCommand2" "$1" "$evalCommand2" $imgNum
				parseXshFile "$1/$evalCommand2" "$1" "$evalCommand2" $4
			fi
		done
		
	elif [ -f "$1" ]; then
		ls "$1" | grep xsh
		if [ $? -eq 0 ]; then
			#echo "File=$1;"
			# 循环读取文件内容
			local filename="$1"
			local username=`iconv -f utf-16le -t utf-8 "$filename"|grep ^UserName|cut -f 2 -d '='`
			local host=`iconv -f utf-16le -t utf-8 "$filename"|grep ^Host|cut -f 2 -d '='`
			local port=`iconv -f utf-16le -t utf-8 "$filename"|grep ^Port|cut -f 2 -d '='`
			echo   "`echo ${parentDirOrFile%%'.xsh'*}`=#109#0%$host%$port%$username%%-1%-1%%%%%0%0%0%%%-1%0%0%0%%1080%%0%0%1#MobaFont%10%0%0%-1%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%-1%_Std_Colors_0_%80%24%0%1%-1%<none>%%0%0%-1#0# #-1" >> $dir/export.txt
			 
			
		fi
	fi
	echo
}



echo "[Bookmarks]" >> $dir/export.txt
echo "SubRep=" >> $dir/export.txt
echo "ImgNum=$imgNum" >> $dir/export.txt

# 自减
let "imgNum=(--imgNum)"
parseXshFile $dir "" "" $imgNum

# 转换字符集：utf-8 -> gbk
iconv -f utf-8 -t gbk "$dir/export.txt" > "$dir/import.mxtsessions"
