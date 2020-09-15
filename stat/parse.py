# parse summary.log into 4 CSVs(comma seperated values)

import os
map_keys = ('lzw', 'zip', 'gzip', 'bz2') # not used

# header detection: ***** and skip null line
def blockDetect(line):
	head_token = line.split(" ")[0]
	if(head_token == "*****"):
		return True
	else:
		return False

# return fileName and typeName
def nameProcessor(line):
	tokens = line.split("/")
	fileName = tokens[-2].split("-")[0]
	typeName = tokens[-1].split(".")[0]
	return fileName, typeName

# return list
def tupleProcessor(line_lst):
	rst = []
	for line in line_lst:
		line = line.split("\n")[0]
		line = line.strip() # remove possible space
		data = line.split(" ")[-1]
		rst.append(str(data))
	return rst

# input: block - list of line
# return target filename and dictionary
def blockProcessor(block):
	block_len_const = 44 # (1+10)*4
	sub_block_len = 11 # per tuple sub-block length

	if( len(block) != block_len_const ):
		return "Unknown", dict()

	map_dict = dict()
	data_lst = []

	for nu in range(len(block)):
		line = block[nu]
		if(nu%sub_block_len == 0):
			# sub-block head
			fileName, typeName = nameProcessor(line)
		else:
			# 10 lines for tuple
			data_lst.append(line)

		if(nu%sub_block_len == 10):
			# subblock finished
			map_dict[typeName] = tupleProcessor(data_lst)
			data_lst.clear()
	
	# dictionary validation
	if( len(map_dict) == 4 ):
		return fileName, map_dict
	else:
		print(fileName + " block process error. Abort!")
		return fileName, dict()
			
# input: fileName - Target task name
# update CSVs in ./batchCSV
def updateCSV(tuple_dict, fileName):
	if( len(tuple_dict) != 4 ):
		return False

	dirPath = os.path.abspath("./batchCSV")
	if( not os.path.isdir(dirPath) ):
		return False

	for key, data_lst in tuple_dict.items():
		wrt_fd = open(dirPath+"/"+key+".csv", "a")
		data_lst = [ str(x) for x in data_lst ]
		line = fileName + ","
		line = line + ",".join(data_lst) + "\n"
		wrt_fd.write(line)
		wrt_fd.close()

	return True





def main():
	# check log file
	sumPath = os.path.abspath("./summary.log")
	if( not os.path.isfile(sumPath) ):
		print(sumPath + " doesn't exist. Abort!")
		return

	# var initialization
	block_len = 44 # (1+10)*4
	block_mode = False
	processor_mode = False
	block_cur = []
	title = "文件名,有效数据长度,平均压缩比（去掉补零位）,平均压缩比（算上补零位）,溢出率（溢出帧占比）,最大压缩时间（ms）,平均压缩时间（ms）,最大压缩时间（ms）,平均压缩时间（ms）,正确率,统计帧数\n"

	# remove header with length = nu = 6
	rd = open(sumPath, 'r')
	content = rd.readlines()
	rd.close()
	nu = 7
	for _ in range(nu):
		content.pop(0)

	dirPath = os.path.abspath("./batchCSV")
	if( not os.path.isdir(dirPath) ):
		os.system("mkdir " + dirPath)
	else:
		cmd = "rm " + dirPath + "/*"
		os.system(cmd)

	for name in map_keys:
		wrt_fd = open(dirPath+"/"+name+".csv", "w")
		wrt_fd.write(title)
		wrt_fd.close()
	
	# parse loop
	for line in content:
		if( not block_mode ):
			# block_mode: False
			block_mode = blockDetect(line)
		else:
			# block_mode: True
			# start right under each title *****
			block_cur.append(line) 
			if(len(block_cur) == block_len):
				processor_mode = True

		if(processor_mode):
			# processor_mode: True
			task_name, tuple_dict = blockProcessor(block_cur) # generate a list containing 4 tuples
			sig = updateCSV(tuple_dict, task_name) # update 4 CSVs
			if(not sig):
				# sig is False
				print("Task " + task_name + " error!") 
			# re-init
			block_cur.clear()
			block_mode = False
			processor_mode = False

	print("-----------------------")
	print("Parse " + sumPath + " succeed.")
	print("Please check " + dirPath + " for results.")
	return 







if __name__ == '__main__':
	main()
