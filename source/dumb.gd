extends Node2D
# I CAN'T CODE, DS
var specialStats:Array = [5,5,5,5,5,5,5]
var realSpecialStats:Array = [5,5,5,5,5,5,5]
var system_to_use:String = 'UER'
var yass_mode:bool = false # This seems odd but YASS has different set variables.
var ta_mode:bool = false # The Aftermath removes moves and pp but still keeps the same variables as FALLMON

var health:int = 35
var stamina:int = 50
var power_points:int = 10
var action_points:float = 7
var rad_resist:float = 0
var ac:float = 0
var defense:float = 0
var curLevel:int = 1
var xp_needed:int = 0
var moveLimit:int = 3
var rad_limit:int = 1000

var character_name:String = ''

var theEntireText:String = ''

var textToDisplay:Array = [
	['',0],
]

var conditions:Array = [
	[30,60,200],
	[5,10,150],
	[20,40,150],
	[20,40,50],
	[20,40,50],
	[20,40,50],
	[20,40,50],
]
var cndType:int = 0
var traitsUsed:Array = [
	['Fit',false], # 0
	['Overweight',false], # 1
	['Obese',false], # 2
	['Underweight',false], # 3
	['Skinny AF',false], # 4
	['Violent',false], # 5
	['Pacifist/No Skill',false], # 6
	['Inconspicuous',false], # 7
	['Conspicuous',false], # 8
	['Saver',false], # 9
	['Clumsy',false], # 10
	['Keen Hearing',false], # 11
	['Hard to Hear',false], # 12
	['Deaf',false], # 13
	['Speed Driver',false], # 14
	['Sunday Driver',false], # 15
	["Can't Drive",false], # 16
	['Brave',false], # 17
	['Coward/Cat',false], # 18
	['Fast Reader',false], # 19
	['Slow Reader',false], # 20
	['Illiterate',false], # 21
	['Good Healer',false], # 22
	['Bad Healer',false], # 23
	['Hemohoic',false], # 24
	['Four Eyes',false], # 25
	['Weak Stomach',false], # 26
	['Brusier',false], # 27
	['Cat Eyes',false], # 28
	['Smoker/Alcoholic',false], # 29
	['Glass Cannon',false], # 30
	['Hitless man',false], # 31
	['Picky',false], # 32
	['Back to the Basics',false], # 33
	['Iron skin',false], # 34
	['Thin skin',false], # 35
	['Blind',false], # 36
	['Oops, My Bad!',false], # 37
]
# Called when the node enters the scene tree for the first time.
func _ready():
	for traitNum in range(0,traitsUsed.size()):
		$TopShit/TraitsList.add_item(traitsUsed[traitNum][0], null, true)

func updateStats():
	textToDisplay = [
		['Strength: ',specialStats[0],realSpecialStats[0], 'STR: '],
		['Perception: ',specialStats[1],realSpecialStats[1], 'PER: '],
		['Endurance: ',specialStats[2],realSpecialStats[2], 'END: '],
		['Charisma: ',specialStats[3],realSpecialStats[3], 'CHA: '],
		['Intelligence: ',specialStats[4],realSpecialStats[4], 'INT: '],
		['Agility: ',specialStats[5],realSpecialStats[5], 'AGL: '],
		['Luck: ',specialStats[6],realSpecialStats[6], 'LUK: '],
		['LE: ',health,null],
		['Stamina: ',stamina,null],
		['AP: ',action_points,null],
		['Rad Resist: ',rad_resist,null],
		['AC: ',ac,null],
		['Defense: ',defense,null],
		#['RAD LIMIT:',rad_limit],
	]

func updateTraits():
	for reset in range(0,realSpecialStats.size()):
		realSpecialStats[reset] = specialStats[reset]
	
	if traitsUsed[0][1] == true:
		realSpecialStats[5] += 1
	if traitsUsed[1][1] == true:
		realSpecialStats[2] -= 3
		realSpecialStats[5] -= 2
	if traitsUsed[2][1] == true:
		realSpecialStats[2] -= 5
		realSpecialStats[5] -= 4
	if traitsUsed[3][1] == true:
		realSpecialStats[2] -= 2
		realSpecialStats[5] += 2
	if traitsUsed[4][1] == true:
		realSpecialStats[2] -= 5
		realSpecialStats[5] += 5
	if traitsUsed[25][1] == true:
		realSpecialStats[1] -= 2
	if traitsUsed[27][1] == true:
		realSpecialStats[0] += 2

func _process(_delta):
	updateStats()
	updateTraits()
	$Info.text = ''
	$TopShit/traitsActive.text = ''
	for i in range(0,textToDisplay.size()):
		$Info.text += str(textToDisplay[i][0]) + str(textToDisplay[i][1])
		if textToDisplay[i][2] != null:
			$Info.text += ' (' + str(textToDisplay[i][2]) + ')'
		$Info.text += ' - '
	for traitNum in range(0,traitsUsed.size()):
		if traitsUsed[traitNum][1] == true:
			$TopShit/traitsActive.text += traitsUsed[traitNum][0] + ', '
	if !yass_mode:
		$Info.text += 'LVL:' + str(curLevel) + '\n'
		$Info.text += 'XP TO NEXT:'
		$Info.text += str(xp_needed) + '\n'
		
		if !ta_mode:
			$Info.text += 'PP:' + str(power_points) + '\n'
			$Info.text += 'MOVE LIMIT:' + str(moveLimit) + '\n'
	
	if system_to_use == 'UER' or system_to_use == 'UE3':
		$specialStats/LUK.editable = true
	else: # Since Luck didn't exist in previous versions
		$specialStats/LUK.editable = false
	
	# HEALTH
	if yass_mode:
		health = 50 + (realSpecialStats[0]*2) + (realSpecialStats[2]*5)
	else:
		health = 20 + realSpecialStats[0] + (realSpecialStats[2]*2)
	# STAMINA
	stamina = realSpecialStats[5]*10
	# POWER POINTS
	power_points = realSpecialStats[0]*2
	# ACTION POINTS
	if system_to_use == 'UE1':
		action_points = int(realSpecialStats[5])
	else:
		action_points = int(5 + (realSpecialStats[5]/2))
	
	# RAD RESIST
	rad_resist = int(realSpecialStats[2]/2)
	# AC and DEFENSE
	if system_to_use == 'UER' or system_to_use == 'UE3':
		defense = int(realSpecialStats[2]/2)
		ac = int((realSpecialStats[5]/2) + (realSpecialStats[1]/2))
	else:
		defense = 0
		ac = realSpecialStats[2]
	# EXP REQUIREMENT
	if yass_mode:
		xp_needed = 0 # curLevels does not exist
	else:
		var next = curLevel + 1
		@warning_ignore("integer_division")
		xp_needed = (next*(next-1)/2)*1000
	# MOVES (FALLMON Only, Maybe added to The Aftermath?)
	moveLimit = 3
	if realSpecialStats[4] > 3:
		moveLimit = 4
	if realSpecialStats[4] > 6:
		moveLimit = 4 + int(realSpecialStats[4] - 6)
	if moveLimit > 8:
		moveLimit = 8
	elif moveLimit < 3:
		moveLimit = 3
	loadText()

func loadText():
	theEntireText = ''
	var divider = ' • '
	var useLuck = 7
	if system_to_use != 'UE3' and system_to_use != 'UER':
		useLuck = 6
	if not yass_mode and not ta_mode:
		if system_to_use != 'UE3' and system_to_use != 'UER':
			divider = ' // '
		theEntireText += 'LE: ' + str(health) + '/' + str(health) + divider + 'HP: 15/15' + divider + 'Radiation: 0/1000'
		if system_to_use == 'UE3' or system_to_use == 'UER':
			theEntireText += divider + 'Rad Resist: ' + str(rad_resist)
		theEntireText += divider + 'Power Points: ' + str(power_points) + '/' + str(power_points) + divider + 'Stamina: ' + str(stamina) + '/' + str(stamina)
		theEntireText += divider + 'AC: ' + str(ac)
		if system_to_use == 'UE3' or system_to_use == 'UER':
			theEntireText += ' • Defense: ' + str(defense)
		theEntireText += divider + 'Blood Type: N/A' + divider + 'EXP: 0/' + str(xp_needed)
		if system_to_use == 'UE3' or system_to_use == 'UER':
			theEntireText += ' • Skill Points: 0'
		else:
			theEntireText += ' // Level: ' + str(curLevel)
		theEntireText += '\n\n**Species** '
		if system_to_use == 'UER' or system_to_use == 'UE3':
			theEntireText += '\n**Abilities** '
		theEntireText += '\n**Item**\nNONE'
		theEntireText += '\n**Effects**\nNONE'
		if system_to_use == 'UER' or system_to_use == 'UE3':
			theEntireText += '\n**Limb Conditions**\nHead (60/60)\nEyes (10/10)\nChest (40/40)\nBelly (40/40)\nArms (40/40)\nLegs (40/40)\n?\nGroin (10/10)'
		else:
			theEntireText += '\n**Limb Conditions**\nHead (30/30)\nEyes (5/5)\nChest (20/20)\nBelly (20/20)\nArms (20/20)\nLegs (20/20)\n?\nGroin (5/5)'
		theEntireText += '\n**SPECIAL**'
		for i in range(0,useLuck):
			theEntireText += '\n' + str(textToDisplay[i][0]) + str(textToDisplay[i][2])
		theEntireText += '\n**TRAITS**'
		var totalActive = 0
		for i in range(0,traitsUsed.size()):
			if traitsUsed[i][1] == true:
				totalActive += 1
				theEntireText += '\n' + str(traitsUsed[i][0])
		if totalActive == 0:
			theEntireText += '\nNONE'
		theEntireText += '\n**PERKS**'
		theEntireText += '\n**MOVES (0/' + str(moveLimit) + ')**'
	
	if ta_mode:
		theEntireText += '**INFO**\nLE: ' + str(health) + '/' + str(health) + '\nHS: 30/30\nSTM: ' + str(stamina) + '/' + str(stamina)
		theEntireText += '\nSPECIES: '
		theEntireText += '\nAC: ' + str(ac) + ' | DEF: ' + str(defense) + ' | RAD Resist: ' + str(rad_resist)
		theEntireText += '\n**SPECIAL**'
		for i in range(0,useLuck):
			theEntireText += '\n' + str(textToDisplay[i][3]) + str(textToDisplay[i][2])
		theEntireText += '\n**Limb Conditions**\nHead (200/200) (Armor: None)\nChest (150/150) (Armor: None)\nBelly (150/150) (Armor: None)\nLeft Arm (50/50) (Armor: None)\nRight Arm (50/50) (Armor: None)\nLeft Leg (50/50) (Armor: None)\nRight Leg (50/50) (Armor: None)\n?'
		theEntireText += '\n**EFFECTS**'
		var totalActive = 0
		for i in range(0,traitsUsed.size()):
			if traitsUsed[i][1] == true:
				totalActive += 1
				theEntireText += '\n[TRAIT] ' + str(traitsUsed[i][0])
		if totalActive == 0:
			theEntireText += '\nNONE'
		theEntireText += '\n**INVENTORY (0/8 | BAG: None)**\nNONE'
		theEntireText += '\n**WEAPONS (0/4)**\nNONE'
	
	if yass_mode:
		theEntireText += '**NAME** ' + character_name + '\n**MAIN INFO**\nLife Energy: ' +  str(health) + '/' + str(health)
		theEntireText += '\nMain Health: 50/50\nStamina: ' + str(stamina) + '/' + str(stamina) + '\nSpecies: \nAge: \nSex: \nHeight: \nWeight: \nAC: ' + str(ac) + '\nDefense: ' + str(defense)
		theEntireText += '\nRadiation: 0%\n**ROLE**\n\n**PRIMARY STATS**'
		for i in range(0,6): # Since Luck does not exist in YASS
			theEntireText += '\n' + str(textToDisplay[i][0]) + str(textToDisplay[i][2])
		theEntireText += '\n**LIMB STATUS**\nHead: OKAY\nChest: OKAY\nBelly: OKAY\nLeft Arm: OKAY\nRight Arm: OKAY\nLeft Leg: OKAY\nRight Leg: OKAY\n?'
		theEntireText += '\n**EFFECTS**\nNONE\n**TRAITS:'
		var totalActive = 0
		for i in range(0,traitsUsed.size()):
			if traitsUsed[i][1] == true:
				totalActive += 1
				theEntireText += '\n' + str(traitsUsed[i][0])
		if totalActive == 0:
			theEntireText += '\nNONE'
		theEntireText += '\n**INVENTORY**\nNONE'
	
	$Char.text = theEntireText

func _on_str_value_changed(value):
	specialStats[0] = value
func _on_per_value_changed(value):
	specialStats[1] = value
func _on_end_value_changed(value):
	specialStats[2] = value
func _on_cha_value_changed(value):
	specialStats[3] = value
func _on_int_value_changed(value):
	specialStats[4] = value
func _on_agl_value_changed(value):
	specialStats[5] = value
func _on_luk_value_changed(value):
	specialStats[6] = value

func _on_system_use_item_selected(index):
	match index:
		1:
			system_to_use = 'UE3' # For FALLMON 2, YASS Lost in Space, and Lost at Sea
		2:
			system_to_use = 'UE2' # For FALLMON Lab Disaster
		3:
			system_to_use = 'TSE' # For Terraria Sugarcoated
		4:
			system_to_use = 'UE1'
		_:
			system_to_use = 'UER' # For The Aftermath and YASS

func _on_yass_toggled(toggled_on):
	yass_mode = toggled_on
	$TopShit/TA.disabled = toggled_on

func _on_ta_toggled(toggled_on):
	$TopShit/YASS.disabled = toggled_on
	ta_mode = toggled_on

func _on_level_value_changed(value):
	curLevel = value

func _on_traits_list_multi_selected(index, selected):
	traitsUsed[index][1] = selected
	print(str(traitsUsed[index][0]) + ':' + str(traitsUsed[index][1]))	
	#for traitNum in range(0,traitsUsed.size()):
	#	print(traitsUsed[traitNum][1])


func _on_reset_traits_pressed():
	for traitNum in range(0,traitsUsed.size()):
		traitsUsed[traitNum][1] = false

func _on_character_name_text_changed(new_text):
	character_name = new_text

var save_path = ""
func saveChar():
	save_path = "user://" + character_name + ".txt"
	if character_name == '':
		save_path = "user://blank.txt"
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	file.store_string(theEntireText)
	file.close()

func openFolders():
	var path = ProjectSettings.globalize_path("user://")

	OS.shell_show_in_file_manager(path, true)
