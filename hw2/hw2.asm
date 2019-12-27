# Homework #2
# name: Kishore Thamilvanan
# sbuid: 111373510

# There should be no .data section in your homework!

.text

###############################
# Part 1 functions
###############################
recitationCount:

    #Define your code here
	############################################
	
	blez $a1, errorReturnF1		#checking if the class size is less than or equal to zero
	
	#Checking for the recitation number to be valid
	li $t1, 8 					
	blt  $a2, $t1, errorReturnF1	#checking the recitation is above 8
	
	li $t1, 11
	beq $a2, $t1, errorReturnF1	#if equal to 11 print -1
	
	li $t1, 14 
	bgt  $a2, $t1, errorReturnF1
	
	addi $t3, $zero, 0				#clears the loop counter variable to zero
	addi $v0, $zero, 0
	loop1:
	
	beq $a1, $t3, loop1End				#stopping condition when the iteration reaches class size
	lb $t0, 14($a0)
	
	li $t1, 0xf					#getting the 14th byte and masking them to obtain just recitation
	and $t0, $t1, $t0
	
	bne $a2, $t0, else1
	addi $v0, $v0, 1				#if the above condition is correct then add 1 to the number of students
	
	else1:
	addi $a0, $a0, 16				#adding 14 to move to the next Student structure
	addi $t3, $t3, 1				#incrementing the loop counter by 1
	j loop1
	
	loop1End:
	j endRecitationCount
		
				
	errorReturnF1:
	li $v0, -1
	
	endRecitationCount:
	############################################

	jr $ra

aveGradePercentage:
    #Define your code here
	############################################
	
	#looping through histogram array to find any negative values
	
	li $t0, 0					#$t0 will be the loop counter
	li $t1, 12
	li $t3, 0					# $t3 is used to check the sum of all the grade count being zero or not
	loopHist:
		beq $t0, $t1, endLoophist			#loop breaking condition	
	
		lw $t2, ($a0)
		add $t3, $t3, $t2
		bltz $t2, errorReturnF2				#if any negative values returning -1
		addi $a0, $a0, 4 				#referring to the next array element
		addi $t0, $t0, 1				#incrementing the loop counter
	
		j loopHist
	endLoophist:
	beqz $t3, errorReturnF2				# if the 
	addi $a0, $a0, -48				#restoring $a0 back at its starting address 
	
	#looping through gradepoints array to find any negative values
	
	li $t0, 0					#$t0 will be the loop counter
	li $t1, 12
	loopGradePoints:
	beq $t0, $t1, endLoopGradePoints		#loop breaking condition	
	
	
	lwc1  $f1, 0($a1)
	mtc1 $zero, $f4 
	c.lt.s $f1, $f4 				#if any value less than 0 returning -1
	bc1t  errorReturnF2
	addi $a1, $a1, 4 				#referring to the next array element
	addi $t0, $t0, 1				#incrementing the loop counter
	
	j loopGradePoints
	endLoopGradePoints:
	addi $a1, $a1, -48				#restoring $a1 back at its starting address 
	
	#calculating average grade value
	li $t0, 0					#$t0 will be the loop counter
	li $t1, 12
  	AvgLoop:
  	beq $t0, $t1, AvgLoopEnd	
	
	lwc1  $f1, 0($a1)				#loading the float value in $f1
	
	lw $t3, 0($a0)					#loading the integer value in $t3
	mtc1  $t3, $f2					#loading the integer value into $f2 register.
	cvt.s.w $f2, $f2				#converting the integer value to a float value
	
	add.s $f5, $f5, $f2				#$f5 has the summation of all frequency
	mul.s $f3, $f1, $f2				# x*f(x)
	add.s $f4, $f4, $f3				#$f4 has the summation of x*f(x)
	
	addi $a0, $a0, 4 				#referring to the next array element
	addi $a1, $a1, 4 				#referring to the next array element
	addi $t0, $t0, 1				#incrementing the loop counter	
	j AvgLoop
	AvgLoopEnd:
	
	#Calculating the average grade percentage
	div.s $f4, $f4, $f5
	mfc1 $v0, $f4
	
	
	j endAvgGradePercentage
	errorReturnF2:
	li $v0, 0xBF800000
	
	endAvgGradePercentage:
	############################################
	jr $ra

favtopicPercentage:
	############################################
	blez $a1, errorReturnF3				#checking whether the classSize is less than or equal to zero or not.
	
	#checking the argument "topics" to be valid 
	blez $a2, errorReturnF3				# if less than zero
	
	li $t0, 15
	bgt $a2, $t0, errorReturnF3 			#if greater than 15
	
	#checking every student's favtopics
	
	addi $t3, $zero, 0				#clears the loop counter variable to zero
	addi $v0, $zero, 0
	loopFav:
	
	beq $a1, $t3, loopFavEnd			#stopping condition when the iteration reaches class size
	lb $t0, 14($a0)
	
	li $t1, 0xF0					#getting the 14th byte and masking them to obtain just fav topics
	and $t0, $t1, $t0
	srl $t0, $t0, 4
	
	and $t4, $a2, $t0	
	blez $t4, else2	
	bgt $t4, $a2, else2				#checking for the student's favtopic
	addi $v0, $v0, 1				#if the above condition is correct then add 1 to the number of students
	
	else2:
	addi $a0, $a0, 16				#adding 16 to move to the next Student structure
	addi $t3, $t3, 1				#incrementing the loop counter by 1
	j loopFav
	
	loopFavEnd:
	
	#calculating the average of fav topic
	
	mtc1 $v0, $f1
	mtc1 $a1, $f2
	div.s $f0, $f1, $f2
	mfc1 $v0, $f0
	
	j endFavTopicPercentage
	errorReturnF3:
	li $v0, 0xBF800000
	
	endFavTopicPercentage:
	############################################
	jr $ra


findFavtopic:
    #Define your code here
	############################################
	
	blez $a1, errorReturnF4				#checking whether the classSize is less than or equal to zero or not.
	
	#checking the argument "topics" to be valid 
	blez $a2, errorReturnF4				# if less than zero
	
	li $t0, 15
	bgt $a2, $t0, errorReturnF4 			#if greater than 15
	
	
	addi $t0, $zero, 0				#clears the loop counter variable to zero
	addi $t6, $zero, 0 				# this will be the sum of the all the fav topics to find whether it is zero or not.
	move $t1, $a1 				
	loopFindFavTopics:
	beq $t0, $t1, endLoopFindFavTopics
	lb $t2, 14($a0)					#loading the 14th byte containing the reciatation and favTopics
	
	li $t3, 0xF0					#getting the 14th byte and masking them to obtain just fav topics
	and $t2, $t2, $t3
	srl $t2, $t2, 4
	   
	and $t2, $t2, $a2				#and-ing topics from class with those of passed to count the number of likes for each topic
	move $t3, $t2					#having a backup of $t2 's value.
	add $t6, $t6, $t3
	
	#$s0, $s1, $s2, $s3 are the counter variable for four diff fav topics
	
	li $t4, 1
	and $t4, $t4, $t2				#obtaining the least significant bit by and-ing it with the value 0001
	add $s0, $s0, $t4 				#adding the the LSB to the count
	
	li $t4, 2
	and $t4, $t4, $t2
	srl $t4, $t4, 1					#moving the second right bit to the LSB position
	add $s1, $s1, $t4	
	
	li $t4, 4
	and $t4, $t4, $t2
	srl $t4, $t4, 2					#moving the third from right bit to the LSB position
	add $s2, $s2, $t4	
	
	li $t4, 8
	and $t4, $t4, $t2
	srl $t4, $t4, 3					#moving the fourth from right bit to the LSB position
	add $s3, $s3, $t4	
	
	else3:
	addi $a0, $a0, 16				#adding 16 to move to the next Student structure
	addi $t0, $t0, 1				#incrementing the loop counter by 1
	j loopFindFavTopics
	
	endLoopFindFavTopics:
	
	beqz $t6, errorReturnF4
	
	#finding the largest of the four numbers 
	
	#assume $s3 to be the greatest for now
	move $t0, $s3					# $t0 contains the largest  
	li $v0, 8
	
	bge $t0, $s2, goto1 				# $s2 is less than 
	move $t0, $s2
	li $v0, 4
	
	goto1: 
	bge $t0, $s1, goto2 				# $s1 is less than 
	move $t0, $s1
	li $v0, 2
	
	goto2:
	bge $t0, $s0, findSecondLargest 				# $s1 is less than 
	move $t0, $s0
	li $v0, 1

	# finding the second largest fav topic
	findSecondLargest:
	
	#finding out the largest number first and checking the rest for the second largest 
															
	beq $v0, 1, fiSecLA1
	beq $v0, 2, fiSecLA2
	beq $v0, 4, fiSecLA4
	beq $v0, 8, fiSecLA8
	
	
	fiSecLA1: 
	move $t0, $s3 					#assuming $s3 to be the largest of the three 
	li $v1, 8
	
	bge $t0, $s2, goThere1 				# $s2 is less than 
	move $t0, $s2
	li $v1, 4
	
	goThere1:
	bge $t0, $s1, endFindFavTopic 				# $s1 is less than 
	move $t0, $s1
	li $v1, 2
	j endFindFavTopic
	
	fiSecLA2: 
	move $t0, $s3 						#assuming $s3 to be the largest of the three 
	li $v1, 8
	
	bge $t0, $s2, goThere2 					# $s2 is less than 
	move $t0, $s2
	li $v1, 4
	
	goThere2:
	bge $t0, $s0, endFindFavTopic 				# $s1 is less than 
	move $t0, $s0
	li $v1, 1
	j endFindFavTopic
	
	fiSecLA4: 
	move $t0, $s3 						#assuming $s3 to be the largest of the three 
	li $v1, 8
	
	bge $t0, $s1, goThere3 					# $s2 is less than 
	move $t0, $s1
	li $v1, 2
	
	goThere3:
	bge $t0, $s0, endFindFavTopic 				# $s1 is less than 
	move $t0, $s0
	li $v1, 1
	j endFindFavTopic
	
	fiSecLA8: 
	move $t0, $s2 						#assuming $s3 to be the largest of the three 
	li $v1, 4
	
	bge $t0, $s1, goThere4 					# $s2 is less than 
	move $t0, $s1
	li $v1, 2
	
	goThere4:
	bge $t0, $s0, endFindFavTopic 				# $s1 is less than 
	move $t0, $s0
	li $v1, 1
	
	

	j endFindFavTopic
	errorReturnF4:
	li $v0, -1
	li $v1, -1
	
	endFindFavTopic:
	############################################
	jr $ra


###############################
# Part 2 functions
###############################

twoFavtopics:
    #Define your code here
	############################################
	
	###### prologue ######
	
	# save the $ra (return address)
	addi $sp, $sp, -4 				#create space 
	sw $ra, 0($sp)					#store the return address

	###### end of prologue ######
	
	
	li $a2, 15
	jal findFavtopic 
	

	###### epilogue ######
	
	#retrieve the return address from the stack.
	lw $ra, 0($sp)					
	addi $sp, $sp, 4					#reseting the stack pointer back to where it was previously.								
	
	###### end of epilogue ###### 
	
	j endTwoFavTopics
	errorReturnTwoFavTopics:
	li $v0, -1
	li $v1, -1 
	
	endTwoFavTopics:
	############################################
	jr $ra


calcAveClassGrade:
    #Define your code here
	############################################
	
	###### prologue ######
	
	# save the $ra (return address)
	addi $sp, $sp, -4 				#create space 
	sw $ra, 0($sp)					#store the return address

	addi $sp, $sp, -4 				#create space 
	sw $s0, 0($sp)					#storing the s register that i use 
	###### end of prologue ######
	
	ble $a1, 0, errorPresent
	
	# A loop to clear all the values in histogram (which is to be used for storing counts)
	
	li $t0, 0					# $t0 will be the loop counter 
	li $t1, 12					# $t1 will be the maximum loop number
	li $t2, 0					# $t2 will contain zero which is to be set to all the values of the histogram.
	clearHistLoop:
	beq $t0, $t1, EndClearHistLoop
	
	sw $t2, 0($a2)					#setting the value of the histogram to be zero initially
		
	addi $a2, $a2, 4				#proceeding to the next element in the array
	addi $t0, $t0, 1				#increasing the loop counter
	j clearHistLoop
	EndClearHistLoop:
	addi  $a2, $a2, -48				#re-assigning the address pointer to the beginning of the histogram array.
	
	 
	 # looping to access all the students and their grades.
	 
	li $t3, 0					# $t0 will be the loop counter 
	move $t1, $a1					# $t1 will be the class size. that many times the loop should run
	studentLoop:					#looping through all the students.
	
		beq $t3, $t1, studentLoopEnd
		lhu $t4, 12($a0)				# $t4 contains the grades of each student.
		#saving the $a0 before I move the getGradeIndex argument into that
		move $s0, $a0
		
		# assigning grade ($t4 as the argument for the getGradeIndex function)
		move $a0, $t4					# $a0 now contains the grade of the student as aargument whcih will be passed to the function
		jal getGradeIndex
		move $t5, $v0					#storing the returned grade index value in $t5	
		beq $v0, -1, end

		#restoring back the student class to $a0
		move $a0, $s0		
		
		sll $t5, $t5, 2
		add $t6, $a2, $t5	
		lw $t7, 0($t6)
		addi $t7, $t7, 1				#adding one to the students hist at that index
		sw $t7, 0($t6)

		addi $t3, $t3, 1				#incrementing the loop counter.
		addi $a0, $a0, 16				#moving out to the next student.S
		j studentLoop
		
	studentLoopEnd:
	
	#restoring the value of $a0
	li $t1, 16    
	mul  $t2, $t3, $t1
	sub $a0, $a0, $t2 					#address restored back to previous value!!
	
	move $a0, $a2						#storing argument (histogram array) as first parameter for the function call avgGradePercentrage
	move $a1, $a3						#storing argument (gradepoints array) as second parameter for the function call avgGradePercentrage
	
	jal aveGradePercentage					#calling the aveGradePercentage fu8nction to get the avg grade percentage
	mtc1 $v0, $f1
	
	li $t1, -1
	mtc1 $t1, $f2 
	c.eq.s $f1, $f2
	bc1t errorPresent
	
	j end
	errorPresent:
	li $t1, -1
	mtc1 $t1, $f2 
	mfc1 $v0, $f2
	
	end:
	
	###### epilogue ######
	 
	lw $s0, 0($sp)					#restoring the s register that I used
	addi $sp, $sp, 4 				
	
	#retrieve the return address from the stack.
	lw $ra, 0($sp)					
	addi $sp, $sp, 4					#reseting the stack pointer back to where it was previously.								
	
	###### end of epilogue ###### 
	
	############################################
	jr $ra


updateGrades:
    #Define your code here
	############################################
	
	###### prologue ######
	
	# save the $ra (return address)
	addi $sp, $sp, -4 				#create space 
	sw $ra, 0($sp)					#store the return address

	addi $sp, $sp, -4 				#create space 
	sw $s0, 0($sp)					#storing the s register that i use 
	
	###### end of prologue ######

	ble $a1, 0, errorReturnUpdateGrades 		# if the class size if less than or equal to zero return error
	
	li $t0, 0
	li $t1, 1
	move $t5, $a2
	outerLoop:
	beq $t0, 11, outerLoopEnd
	lw $t2, 0($t5)
	mtc1 $t2, $f1
	move $t6, $t5
		innerLoop:
		beq $t1, 12, innerLoopEnd 
		
		lw $t3, 4($t6)
		mtc1 $t3, $f2

		c.le.s $f1, $f2
		bc1t errorReturnUpdateGrades		
	
		addi $t6, $t6, 4
		addi $t1, $t1, 1
		j innerLoop
		innerLoopEnd:
	
	addi $t5, $t5, 4
	addi $t0, $t0, 1
	addi $t1, $t0, 1
	j outerLoop
	outerLoopEnd:


	
	li $t3, 0					# $t0 will be the counter of this loop.
	
	#this loop runs for class size number of times (number of students sent as argument)
	updateGradesLoop:
	beq $t3, $a1 endUpdateGradesLoop 
		
	lw $t2, 8($a0)
	mtc1 $t2, $f0 				#accessing the float percentile of the student and storing it in coproc 1
	
	li $t1, 0 					# $t1 will be the counter for inner loops
	getGradeLoop:
		beq $t1, 12, endGetGradeLoop
		
		lw $t2, 0($a2)
		mtc1 $t2, $f1
		c.le.s $f1, $f0				# checking if the cuttoff is less than or equal 
		bc1f skipToNextValue			# then get the appropriate grade
							
	   	# we send the index number of the loop as argument to retreive the grade assosciated with it 
	   	# the index number of this inner loop (getGradeLoop) is $t1

	   	# ** before we move the inde to $a0, we have to save the contents of $a0 somewhere else.
	   	move $s0, $a0
	   		   		   	
	   	move $a0, $t1				# storing the argument (index of the inner loop) which is to be passed on to the $a0 
	   	jal getGrade				# calling the get grade function... it returns the return value in $v0
	   	bltz $v0, skipToNextValue		# in case the function returns an error (-1)
	   	move $t2, $v0				# storing the function returned grade to a temp register
	   	
	   	# ** restoring the contents of $a0 back to it.
	   	move $a0, $s0
		sh $t2, 12($a0)				# changing the grade in the student structure in the memory.  
	   	j endGetGradeLoop			# since the student structure has been identified and changed we dont have to loop anymore
	   	
	      	skipToNextValue:
		addi $t1, $t1, 1			# incrementing the loop counter.
		addi $a2, $a2, 4
		j getGradeLoop
	endGetGradeLoop: 
	
	#restoring $a2 wiht the previous address    
	sll  $t2, $t1, 2
	sub $a2, $a2, $t2 				#address restored back to previous value!!
	
	addi $t3, $t3, 1				# incrementing the loop counter.
	addi $a0, $a0, 16
	j updateGradesLoop
	endUpdateGradesLoop:
	
	#retsoring the previous address of $a0
	li $t1, 16    
	mul  $t2, $t3, $t1
	sub $a0, $a0, $t2 					#address restored back to previous value!!
	li $v0, 0						# if the control reaches this line then it means it suceeded.

	j endUpdateGrades	
	errorReturnUpdateGrades:
	li $v0, -1

	endUpdateGrades:
	###### epilogue ######
	 
	lw $s0, 0($sp)					#restoring the s register that I used
	addi $sp, $sp, 4
	
	#retrieve the return address from the stack.
	lw $ra, 0($sp)					
	addi $sp, $sp, 4					#reseting the stack pointer back to where it was previously.								
	
	###### end of epilogue ###### 
	
	############################################

	jr $ra

###############################
# Part 3 functions
###############################

find_cheaters:
    #Define your code here
	############################################
	
	# epilogue 
	addi $sp, $sp, -32
	
	
	sw $s7, 0($sp)
	sw $s6, 4($sp)
	sw $s5, 8($sp)
	sw $s4, 12($sp)
	sw $s3, 16($sp)
	sw $s2, 20($sp)
	sw $s1, 24($sp)
	sw $s0, 28($sp)
	
	
	
	
	
	
	#checking for the rows and coloumns to be greater than zero
	
	blez $a1, errorReturn2DArrays					# checking th number of rows and coloumns are greater than zero or not.
	blez $a2, errorReturn2DArrays 
	
	move $v0, $a3					#saving the address of the a3 in v0 so that we could restore it
	
	move $t0, $a0 
	move $t1, $a1   					# number of rows
	move $t2, $a2 					# number of columns

	li $t3, 0  					# i, row counter
	li $s0, 0					# this register will store the number of students present
	li $s4, 0					# this is to keep count of the number of students
	li $s3, 0					# to keep track of number of cheaters
	
	rows:
	li $t4, 0  					# j, column counter
	cols:
		# Although this array traversal could be implemented by simply
		# adding 4 to a starting address (e.g., matrix's address), the
		# point here is to show the arithmetic of computing the address
		# of an element in a 2D array.
		
		# addr = base_addr + i * num_columns * elem_size_in_bytes + j * elem_size_in_bytes
		# addr = base_addr + elem_size_in_bytes * (i * num_columns + j)
	
		mul $t5, $t3, $t2 				# i * num_columns
		add $t5, $t5, $t4 				# i * num_columns + j
		sll $t5, $t5, 2   				# 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
		add $t5, $t5, $t0				# base_addr + 4*(i * num_columns + j)
		
		# $t5 is the register referring to the current node where ever in the array
		
		lw $t6, 0($t5)      				# $t6 contains the grade of the current guy.
		move $s6, $t6					# $s6 contains the grade of the current guy.
		bnez $t6, getTheAdjacentGuysGrade	
		lw $t6, 4($t5)					# loading the value of the student structure.
		beqz $t6, moveToNextNode 			# if thats also zero then there is no student at that particular place.
			
		getTheAdjacentGuysGrade:
		
			loopThroughNeighbors:			# this will loop through all the eight neighbors ( will have eight checking condtions ). 
			
			#checking the guy at the top left of the current student
			move $s1, $t3				# sending i to the s register to check for (i-1) > 0 
			li $t7, 1
			sub $s1, $s1, $t7
			bltz $s1, checkTop 		# *******  condition
			
			move $s2, $t4				# sending j to the s register to check for (j-1) > 0
			sub $s2, $s2, $t7
			bltz $s2, checkTop 		# *******  condition
			
			# IF THE CONTROL COMES HERE THEN IT MEANS BOTH THE CONDITIONS ARE FALSE THEREBY THERE EXIST A TOP LEFT GUY FOR THE CURRENT NODE
			
			move $s7, $t5					# moving the base address to $s7
			mul $s7, $t3, $t2	 				# i * num_columns
			add $s7, $s7, $t4 				# i * num_columns + j
			sll $s7, $s7, 2   				# 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
			add $s7, $s7, $t0				# base_addr + 4*(i * num_columns + j)
		
			lw $t6, 0($s7)					# now the $t6 contains the grade of the topLeftGuy 
			bne $t6, $s6, checkTop
			
			lw $s5, 4($s7)					# getting the address of the student structure
			sw $s5, 4($a3)					# getting the netID of the cheated guy (the current checking guy)
			addi $a3, $a3, 4				# and storing the address of the current checking guy or the cheated guy
			addi $s3, $s3, 1				#adding the count of cheater
			
			
			
			
			checkTop:
			
			#checking the guy above the current student
			move $s1, $t3				# sending i to the s register to check for (i-1) > 0 
			li $t7, 1
			sub $s1, $s1, $t7
			bltz $s1, checkTopRight 		# *******  condition
			
			move $s2, $t4				# sending j to the s register to check for (j) > 0
			bltz $s2, checkTopRight 		# *******  condition
			
			# IF THE CONTROL COMES HERE THEN IT MEANS BOTH THE CONDITIONS ARE FALSE THEREBY THERE EXIST A TOP LEFT GUY FOR THE CURRENT NODE
			
			move $s7, $t5					# moving the base address to $s7
			mul $s7, $t3, $t2	 				# i * num_columns
			add $s7, $s7, $t4 				# i * num_columns + j
			sll $s7, $s7, 2   				# 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
			add $s7, $s7, $t0				# base_addr + 4*(i * num_columns + j)
		
			lw $t6, 0($s7)					# now the $t6 contains the grade of the topLeftGuy 
			bne $t6, $s6, checkTopRight
			
			lw $s5, 4($s7)					# getting the address of the student structure
			sw $s5, 4($a3)					# getting the netID of the cheated guy (the current checking guy)
			addi $a3, $a3, 4				# and storing the address of the current checking guy or the cheated guy
			addi $s3, $s3, 1				#adding the count of cheater
			
			
			
			
			checkTopRight:
			
			#checking the guy above the current student
			move $s1, $t3				# sending i to the s register to check for (i-1) > 0 
			li $t7, 1
			sub $s1, $s1, $t7
			bltz $s1, checkRight 		# *******  condition
			
			move $s2, $t4				# sending j to the s register to check for (j+1) > 0
			add $s2, $s2, $t7
			bgt $s2, $t2, checkRight 		# *******  condition
			
			# IF THE CONTROL COMES HERE THEN IT MEANS BOTH THE CONDITIONS ARE FALSE THEREBY THERE EXIST A TOP LEFT GUY FOR THE CURRENT NODE
			
			move $s7, $t5					# moving the base address to $s7
			mul $s7, $t3, $t2	 				# i * num_columns
			add $s7, $s7, $t4 				# i * num_columns + j
			sll $s7, $s7, 2   				# 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
			add $s7, $s7, $t0				# base_addr + 4*(i * num_columns + j)
			
			lw $t6, 0($s7)					# now the $t6 contains the grade of the topLeftGuy 
			bne $t6, $s6, checkRight
			
			lw $s5, 4($s7)					# getting the address of the student structure
			sw $s5, 4($a3)					# getting the netID of the cheated guy (the current checking guy)
			addi $a3, $a3, 4				# and storing the address of the current checking guy or the cheated guy
			addi $s3, $s3, 1				#adding the count of cheater
			
			
			
			
			checkRight:
			
			#checking the guy above the current student
			move $s1, $t3				# sending i to the s register to check for (i) > 0 
			li $t7, 1

			bltz $s1, checkBottomRight 		# *******  condition
			
			move $s2, $t4				# sending j to the s register to check for (j+1) > 0
			add $s2, $s2, $t7
			bgt $s2, $t2, checkBottomRight 		# *******  condition
			
			# IF THE CONTROL COMES HERE THEN IT MEANS BOTH THE CONDITIONS ARE FALSE THEREBY THERE EXIST A TOP LEFT GUY FOR THE CURRENT NODE
			
			move $s7, $t5					# moving the base address to $s7
			mul $s7, $t3, $t2	 				# i * num_columns
			add $s7, $s7, $t4 				# i * num_columns + j
			sll $s7, $s7, 2   				# 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
			add $s7, $s7, $t0				# base_addr + 4*(i * num_columns + j)
		
			lw $t6, 0($s7)					# now the $t6 contains the grade of the topLeftGuy 
			bne $t6, $s6, checkBottomRight
			
			lw $s5, 4($s7)					# getting the address of the student structure
			sw $s5, 4($a3)					# getting the netID of the cheated guy (the current checking guy)
			addi $a3, $a3, 4				# and storing the address of the current checking guy or the cheated guy
			addi $s3, $s3, 1				#adding the count of cheater
			
			
			
			
			checkBottomRight:
			
			#checking the guy above the current student
			move $s1, $t3				# sending i to the s register to check for (i+1) > 0 
			li $t7, 1
			add $s1, $s1, $t7
			bgt $s1, $t1, checkBottom 		# *******  condition
			
			move $s2, $t4				# sending j to the s register to check for (j+1) > 0
			add $s2, $s2, $t7
			bgt $s2, $t2, checkBottom 		# *******  condition
			
			# IF THE CONTROL COMES HERE THEN IT MEANS BOTH THE CONDITIONS ARE FALSE THEREBY THERE EXIST A TOP LEFT GUY FOR THE CURRENT NODE
			
			move $s7, $t5					# moving the base address to $s7
			mul $s7, $t3, $t2	 				# i * num_columns
			add $s7, $s7, $t4 				# i * num_columns + j
			sll $s7, $s7, 2   				# 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
			add $s7, $s7, $t0				# base_addr + 4*(i * num_columns + j)
		
			lw $t6, 0($s7)					# now the $t6 contains the grade of the topLeftGuy 
			bne $t6, $s6, checkBottom
			
			lw $s5, 4($s7)					# getting the address of the student structure
			sw $s5, 4($a3)					# getting the netID of the cheated guy (the current checking guy)
			addi $a3, $a3, 4				# and storing the address of the current checking guy or the cheated guy
			addi $s3, $s3, 1				#adding the count of cheater
			
			
			
			
			checkBottom:
			
			#checking the guy above the current student
			move $s1, $t3				# sending i to the s register to check for (i+1) > 0 
			li $t7, 1
			add $s1, $s1, $t7
			bgt $s1, $t1, checkBottomleft 		# *******  condition
			
			move $s2, $t4				# sending j to the s register to check for (j) > 0
			bgt $s2, $t2, checkBottomleft 		# *******  condition
			
			# IF THE CONTROL COMES HERE THEN IT MEANS BOTH THE CONDITIONS ARE FALSE THEREBY THERE EXIST A TOP LEFT GUY FOR THE CURRENT NODE
			
			move $s7, $t5					# moving the base address to $s7
			mul $s7, $t3, $t2	 				# i * num_columns
			add $s7, $s7, $t4 				# i * num_columns + j
			sll $s7, $s7, 2   				# 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
			add $s7, $s7, $t0				# base_addr + 4*(i * num_columns + j)
		
			lw $t6, 0($s7)					# now the $t6 contains the grade of the topLeftGuy 
			bne $t6, $s6, checkBottomleft
			
			lw $s5, 4($s7)					# getting the address of the student structure
			sw $s5, 4($a3)					# getting the netID of the cheated guy (the current checking guy)
			addi $a3, $a3, 4				# and storing the address of the current checking guy or the cheated guy
			addi $s3, $s3, 1				#adding the count of cheater
			
			
			
			
			checkBottomleft:
			
			#checking the guy above the current student
			move $s1, $t3				# sending i to the s register to check for (i+1) > 0 
			li $t7, 1
			add $s1, $s1, $t7
			bgt $s1, $t1, checkLeft 		# *******  condition
			
			move $s2, $t4				# sending j to the s register to check for (j-1) > 0
			sub $s2, $s2, $t7
			bltz $s2, checkLeft	 		# *******  condition
			
			# IF THE CONTROL COMES HERE THEN IT MEANS BOTH THE CONDITIONS ARE FALSE THEREBY THERE EXIST A TOP LEFT GUY FOR THE CURRENT NODE
			
			move $s7, $t5					# moving the base address to $s7
			mul $s7, $t3, $t2	 				# i * num_columns
			add $s7, $s7, $t4 				# i * num_columns + j
			sll $s7, $s7, 2   				# 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
			add $s7, $s7, $t0				# base_addr + 4*(i * num_columns + j)
		
			lw $t6, 0($s7)					# now the $t6 contains the grade of the topLeftGuy 
			bne $t6, $s6, checkLeft
			
			lw $s5, 4($s7)					# getting the address of the student structure
			sw $s5, 4($a3)					# getting the netID of the cheated guy (the current checking guy)
			addi $a3, $a3, 4				# and storing the address of the current checking guy or the cheated guy
			addi $s3, $s3, 1				#adding the count of cheater
			
			
			
			
			checkLeft:
			
			#checking the guy above the current student
			move $s1, $t3				# sending i to the s register to check for (i) > 0 
			li $t7, 1
			bltz $s1, endLoopThroughNeighbors 		# *******  condition
			
			move $s2, $t4				# sending j to the s register to check for (j-1) > 0
			sub $s2, $s2, $t7
			bltz $s2, endLoopThroughNeighbors 		# *******  condition
			
			# IF THE CONTROL COMES HERE THEN IT MEANS BOTH THE CONDITIONS ARE FALSE THEREBY THERE EXIST A TOP LEFT GUY FOR THE CURRENT NODE
			
			move $s7, $t5					# moving the base address to $s7
			mul $s7, $t3, $t2	 				# i * num_columns
			add $s7, $s7, $t4 				# i * num_columns + j
			sll $s7, $s7, 2   				# 4*(i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
			add $s7, $s7, $t0				# base_addr + 4*(i * num_columns + j)
		
			lw $t6, 0($s7)					# now the $t6 contains the grade of the topLeftGuy 
			bne $t6, $s6, endLoopThroughNeighbors
			
			lw $s5, 4($s7)					# getting the address of the student structure
			sw $s5, 4($a3)					# getting the netID of the cheated guy (the current checking guy)
			addi $a3, $a3, 4				# and storing the address of the current checking guy or the cheated guy
			addi $s3, $s3, 1				#adding the count of cheater
			
			endLoopThroughNeighbors:
			addi $s0, $s0, 1				#incrementing the student count by one. since he is present 
		
		#restore the address of the a3 back
		move $a3, $v0
		
		
		addi $s4, $s4, 1
		moveToNextNode:
		addi $t4, $t4, 1  				# j++
		blt $t4, $t2, cols
	colsEnd:

	addi $t3, $t3, 1 					# i++
	blt $t3, $t1, rows

	rowsEnd:
	
		#this loop checks the the cheaters array if there are redundant students
		
		li $t0, 0
		li $t1, 1
		
		move $t5, $a3
		move $t6, $a3
		
	checkLoop:
		beq $t0, $s3, checkLoopEnd
		lw $t2, 0($a3)					# t2 contains the netID to be checked.
		
			checkerLoop:
			beq $t1, $s3, checkerLoopEnd 
			
			lw $t3, 4($a3)				# t3 contains the netID of the next guy and the further people inside the loop.
			bne $t3, $t2, skipGod 
			addi $s3, $s3, -1			# if they are equal then it reduces the number of redundant students by one. 		
		
			skipGod:
			addi $t6, $t6, 4
			addi $t1, $t1, 1
			j checkerLoop
			checkerLoopEnd:
		
		addi $t5, $t5, 4
		addi $t0, $t0, 1
		addi $t1, $t0, 1
		j checkLoop

	checkLoopEnd: 

	li $t1, 10
	div $s3, $t1
	mfhi $s3 
	
	move $v1, $s4
	move $v0, $s3
	
	j funcEnd
	errorReturn2DArrays:
	li $v0, -1
	li $v1, -1
	
	funcEnd:
	
	# epilogue 
	
	
	lw $s0, 28($sp)
	lw $s1, 24($sp)
	lw $s2, 20($sp)
	lw $s3, 16($sp)
	lw $s4, 12($sp)
	lw $s5, 8($sp)
	lw $s6, 4($sp)
	lw $s7, 0($sp)
	
	addiu $sp, $sp, 32
	
	
	
	############################################
	jr $ra

