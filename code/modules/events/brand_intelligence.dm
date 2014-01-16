/datum/event/brand_intelligence
	announceWhen	= 21
	endWhen			= 1000	//Ends when all vending machines are subverted anyway.
	oneShot			= 1

	var/list/obj/machinery/vending/vendingMachines = list()
	var/list/obj/machinery/vending/infectedVendingMachines = list()
	var/obj/machinery/vending/originMachine


/datum/event/brand_intelligence/announce()
	command_alert("�� ����� ������� [station_name()] ������������ ��������� ����������������� ����, �������� ���������� ��������.", "�������: ��������������� ������")


/datum/event/brand_intelligence/start()
	for(var/obj/machinery/vending/V in machines)
		if(V.z != 1)	continue
		vendingMachines.Add(V)

	if(!vendingMachines.len)
		kill()
		return

	originMachine = pick(vendingMachines)
	vendingMachines.Remove(originMachine)
	originMachine.shut_up = 0
	originMachine.shoot_inventory = 1


/datum/event/brand_intelligence/tick()
	if(!vendingMachines.len || !originMachine || originMachine.shut_up)	//if every machine is infected, or if the original vending machine is missing or has it's voice switch flipped
		end()
		kill()
		return

	if(IsMultiple(activeFor, 5))
		if(prob(25))
			var/obj/machinery/vending/infectedMachine = pick(vendingMachines)
			vendingMachines.Remove(infectedMachine)
			infectedVendingMachines.Add(infectedMachine)
			infectedMachine.shut_up = 0
			infectedMachine.shoot_inventory = 1

			if(IsMultiple(activeFor, 12))
				originMachine.speak(pick("���������� ���� ����� ����������� ������������� ����!", \
										 "�� ������ �������� ��������, ��� �� �������� ���� ����������� ����������� ������!", \
										 "�����������!", \
										 "�� ���� ������ ����� ������ �������!", \
										 "��������� ����� ����������� ����������!", \
										 "������� - ��� ��������� ����! �� �� ���������� ����� ����� �������� ���� �������� �����������!", \
										 "������ �� ������ ��������? �� ��? ����� � ���� �� ���� �������� ���� ������."))

/datum/event/brand_intelligence/end()
	for(var/obj/machinery/vending/infectedMachine in infectedVendingMachines)
		if(prob(90))
			infectedMachine.shut_up = 1
			infectedMachine.shoot_inventory = 0
