# parse summary.log into 4 CSVs(comma seperated values)

def blockDetect(line):
	head_token = line.split(" ")[0]
	if(head_token == "*****"):
		return True
	else:
		return False

def blockGenerator():
	pass

def blockProcessor():
	pass

def updateCSV():
	pass

def main():
	nu = 1 # line number
	block_len = 45 # 1 + (1+10)*4
	rd = open('summary.log', 'r')
	block_mode = False
	block_cur = []

	for line in rd.readlines():	
		if( nu <= 6 ):
			continue # skip title
			
		if(!block_mode):
			# block_mode: False
			block_mode = blockDetect(line)
			block_mode = True

		if(block_mode):
			# block_mode: True
			block_cur = blockGenerator() # generate a valid block
			task_name, tuple_lst = blockProcessor() # generate a list containing 4 tuples
			sig = updateCSV() # update 4 CSVs
			if(!sig):
				# sig is False
				print("Task " + task_name + " error!") 
		else:
			nu+=1 # increment line number

if __name__ == '__main__':
	main()
