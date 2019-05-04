def read_int32_B(_mode)
	if _mode == 1
		return $block_info.read(4).unpack("V").join.to_i
	elsif _mode == 2
		return $dep_all.read(4).unpack("V").join.to_i
	elsif _mode == 3
		return $bytes_block_info.read(4).unpack("V").join.to_i
	end
end
def str_magic(_str)
	re_size=_str.to_s.size.to_i
	r_wz=$block_info.read(re_size).to_s
	if r_wz == _str
		#puts "#{_str} √"
	else
		throw "wrong file"
	end
end

def read_str
	size=$dep_all.read(1).unpack("C").join.to_i
	test_sz=$dep_all.read(1).unpack("C").join.to_i
	if test_sz == 1
		return $dep_all.read(size)
	else
		return ((([test_sz].pack("C")).to_s)+(($dep_all.read(size-1)).to_s))
	end
end

def segmentation_file(_name,_off,_size,_block_id)
	if FileTest::exists?("ab/"+_name)
		puts "#{_name} is presence"
	else
		use_file=File.open("BLOCK/BLOCK"+_block_id+".block","rb")
		write_file=File.open("ab/"+_name,"wb")
		use_file.seek(_off)
		write_file.print use_file.read(_size)
		write_file.close
		use_file.close
	end
end

def make_floder_Core(_folder)
	if File.directory?(_folder)
	else
		Dir.mkdir(_folder)
	end
end
block_kg=0
$block_info=File.open("BLOCK/BLOCK.blockinfo")
$dep_all=File.open("dep.all")

make_floder_Core("ab")

str_magic("ABBB")
files_count=read_int32_B(1)
$name_id=[0]
$block_id=[0]
$start_off=[0]
$size=[0]
for i in 0..(files_count-1)
	$name_id[i]=read_int32_B(1)
	$block_id[i]=read_int32_B(1)
	$start_off[i]=read_int32_B(1)
	$block_info.read(4)
	$size[i]=read_int32_B(1)
	$block_info.read(4)
	#print "start=",start_off.to_s(16),",size=",size.to_s(16),",unk1=",unk1,",block=",block_id,"\n"
end

$dep_all.read(4)
abdb_count=read_int32_B(2)
$dep_name=[0]
for i in 0..(abdb_count-1)
	$dep_name[i]=read_str
end
#print $block_id
for i in 0..(abdb_count-1)
	#puts $block_id[i]
	segmentation_file($dep_name[i],$start_off[i],$size[i],$block_id[i].to_s)
end
puts "done!"
