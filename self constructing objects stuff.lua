--I wanted a way to work with things that can't happen in a single run of the code as easily as I can use functions, so I started making these
--I'm calling them "self making/constructing objects" since thats effectively what they do, if they don't exist and you try to use them, they just make themselves

--For all of these you need to provide a name to the spot input, that NEEDS to be unique to THAT KIND of function, and it needs to be in quotes
--F.ex if you've got the delta function and the pulse function, you can have one pulse(blabla1,"name1") and one delta(blabla2,"name1"). 
--But you cant have two "name1" in the same kind of function. Like, delta(blabla1,"name1") and delta(blabla2,"name1") in the same script wouldn't work

--Realized just now that the minified versions WILL interfere with each other if you have the name spot for any different kind of function.
--I will go through and make them make different master tables at some point but for now keep that in mind, spot needs to be unique across functions too.

--DELTA
--same as the logic block, delta of the input number over two ticks
--DELTA unminified
function delta(var,spot)
  if not deltaTable then
    deltaTable = {}
    deltaTable[spot] = {oldVar = 0,deltaVar = 0}
  elseif not deltaTable[spot] then
    deltaTable[spot] = {oldVar = 0,deltaVar = 0}
  end
    deltaTable[spot].deltaVar = var - deltaTable[spot].oldVar
    deltaTable[spot].oldVar = var

  return deltaTable[spot].deltaVar
end

--DELTA minified
function delta(c,b)if not a then a={}a[b]={oldVar=0,deltaVar=0}elseif not a[b]then a[b]={oldVar=0,deltaVar=0}end;a[b].deltaVar=c-a[b].oldVar;a[b].oldVar=c;return a[b].deltaVar end

--DELTA example (for Pony IDE)
ign = input.getNumber
function onTick()
	print(delta(ign(1),"name1"))
	print(delta(ign(2),"name2"))
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Next

-- 3d vector delta
--requires vec() and subt() from pols/kubson style vector library, subt requires add(), multf(), and invert()
-- unminified
function vDelta(vec,spot)
  if not vDeltaTable then
    vecDeltaTable = {}
    vecDeltaTable[spot] = {oldVec = vec(),deltaVec = vec()}
  elseif not vecDeltaTable[spot] then
    vecDeltaTable[spot] = {oldVec = vec(),deltaVec = vec()}
  end
    vecDeltaTable[spot].deltaVec = subt(vec,vecDeltaTable[spot].oldVec)
    vecDeltaTable[spot].oldVec = vec

  return vecDeltaTable[spot].deltaVec
end

-- minified
function vecDelta(d,b)if not a then a={}a[b]={oldVec=vec(),deltaVec=vec()}elseif not a[b]then a[b]={oldVec=vec(),deltaVec=vec()}end;a[b].deltaVec=subt(d,a[b].oldVec)a[b].oldVec=d;return a[b].deltaVec end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Next

--PULSE
--same as the logic block, a pulse of the input bool
--PULSE unminified
function pulse(var,spot)
  if not pulseTable then
    pulseTable = {}
    pulseTable[spot] = {pulse = false,touch = false}
  elseif not pulseTable[spot] then
    pulseTable[spot] = {pulse = false,touch = false}
  end
  pulseTable[spot].pulse = var ~= pulseTable[spot].touch and var
  pulseTable[spot].touch = var
  return pulseTable[spot].pulse
end

--PULSE minified
function pulse(c,b)if not a then a={}a[b]={pulse=false,touch=false}elseif not a[b]then a[b]={pulse=false,touch=false}end;a[b].pulse=c~=a[b].touch and c;a[b].touch=c;return a[b].pulse end

--PULSE example (for Pony IDE)
ign = input.getBool
function onTick()
    if pulse(ign(1),"name1") then
        print("pulse 1")
    end
    if pulse(ign(2),"name2") then
        print("pulse 2")
    end
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Next

--PID
--does not have bias or integral windup prevention, will add at some point
--setpoint expects number, processVar expects number, tunes expects a table with kP at table.p, kI at table.i, and kD at table.d
--PID unminified
function pid(setpoint,processVar,tunes,spot)
    if not pidTable then
        pidTable = {}
        pidTable[spot] = {error=0,integral=0,derivative=0,errorPrior=0,integralPrior=0}
    elseif not pidTable[spot] then
        pidTable[spot] = {error=0,integral=0,derivative=0,errorPrior=0,integralPrior=0}
    end
    pidTable[spot].error = setpoint - processVar
    pidTable[spot].integral = pidTable[spot].integralPrior + pidTable[spot].error
    pidTable[spot].derivative = pidTable[spot].error - pidTable[spot].errorPrior
    
    pidTable[spot].controlOutput = tunes.p * pidTable[spot].error + tunes.i * pidTable[spot].integral + tunes.d * pidTable[spot].derivative
    
    pidTable[spot].errorPrior = pidTable[spot].error
    pidTable[spot].integralPrior = pidTable[spot].integral
    
    return pidTable[spot].controlOutput
end

--PID minified
function f(d,e,c,b)if not a then a={}a[b]={error=0,integral=0,derivative=0,errorPrior=0,integralPrior=0}elseif not a[b]then a[b]={error=0,integral=0,derivative=0,errorPrior=0,integralPrior=0}end;a[b].error=d-e;a[b].integral=a[b].integralPrior+a[b].error;a[b].derivative=a[b].error-a[b].errorPrior;a[b].controlOutput=c.p*a[b].error+c.i*a[b].integral+c.d*a[b].derivative;a[b].errorPrior=a[b].error;a[b].integralPrior=a[b].integral;return a[b].controlOutput end

--PID example (for Pony IDE)


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Next

--BEEPER
--if input bool is true then it will return true every ticks ticks
--BEEPER unminified
function beep(bool,ticks,spot)
	if not beepTable then
		beepTable = {}
		beepTable[spot] = {i=0}
	elseif not beepTable[spot] then
		beepTable[spot] = {i=0}
	end
	if bool then
		if beepTable[spot].i > ticks then
			beepTable[spot].i = 0
			return true
		else
			beepTable[spot].i = beepTable[spot].i + 1
			return false
		end
	else
		beepTable[spot].i = 0
		return false
	end
end

--BEEPER minified
function beep(c,d,b)if not a then a={}a[b]={i=0}elseif not a[b]then a[b]={i=0}end;if c then if a[b].i>d then a[b].i=0;return true else a[b].i=a[b].i+1;return false end else a[b].i=0;return false end end

--BEEPER example (for Pony IDE)
ign,pgn = input.getNumber,property.getNumber
function onTick()
	if beep(true,30,"name1") then
		print("beep 1")
	end
	if beep(true,40,"name2") then
		print("beep 2")
	end
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Next

--DELAY
--like a capacitor with only charge. If true, output true after ticks ticks
--tbh just use capacitor function below with 0 chargeTicks instead, might get rid of this
--DELAY unminified
function delay(bool,ticks,spot)
	if not delayTable then
		delayTable = {}
		delayTable[spot] = {i=0}
	elseif not delayTable[spot] then
		delayTable[spot] = {i=0}
	end
	if bool then
		if (delayTable[spot].i > ticks) then
			return true
		else
			delayTable[spot].i = delayTable[spot].i + 1
			return false
		end
	else
		delayTable[spot].i = 0
	end
end

--DELAY minified
function delay(c,d,b)if not a then a={}a[b]={i=0}elseif not a[b]then a[b]={i=0}end;if c then if a[b].i>d then return true else a[b].i=a[b].i+1;return false end else a[b].i=0 end end

--DELAY example (for Pony IDE)
ign,pgn = input.getNumber,property.getNumber
function onTick()
	if delay(true,30,"name1") then
		print("delay 1 done")
	end
	if delay(true,40,"name2") then
		print("delay 2 done")
	end
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Next

--CAPACITOR
--should work exactly like the logic block with the same name. bool is the input, chargeTicks & dischargeTicks are charge and discharge but in ticks, not seconds
--CAPACITOR unminified
function capacitor(bool,chargeTicks,dischargeTicks,spot)
	if not delayTable then
		delayTable = {}
		delayTable[spot] = {i1=0,i2=0}
	elseif not delayTable[spot] then
		delayTable[spot] = {i1=0,i2=0}
	end
	if bool then
		if delayTable[spot].i1 >= chargeTicks then
			delayTable[spot].i2 = dischargeTicks
			return true
		else
			delayTable[spot].i1 = delayTable[spot].i1 + 1
			return false
		end
	else
		if delayTable[spot].i2 == 0 then
			return false
		else
			delayTable[spot].i2 = delayTable[spot].i2 - 1
			return true
		end
	end
end

--CAPACITOR minified
function capacitor(c,d,e,b)if not a then a={}a[b]={i1=0,i2=0}elseif not a[b]then a[b]={i1=0,i2=0}end;if c then if a[b].i1>=d then a[b].i2=e;return true else a[b].i1=a[b].i1+1;return false end else if a[b].i2==0 then return false else a[b].i2=a[b].i2-1;return true end end end

--CAPACITOR example (for Pony IDE)
igb,pgn = input.getBool,property.getNumber
function onTick()
	if capacitor(igb(1),0,3,"name1") then
		print("1 true")
	end
	if capacitor(igb(2),0,4,"name2") then
		print("2 true")
	end
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Next

--ADVANCED DELTA
--takes the delta of c over n ticks, b is spot
--ADVANCED DELTA unminified
function delta(c,b,n)
	if not a then
		a={} a[b]={}
		a[b].deltaVar=0
		a[b].last={}
		for i=1,100 do
			a[b].last[i]=0
		end
	elseif not a[b] then
		a[b]={}
		a[b].deltaVar=0
		a[b].last={}
		for i=1,100 do
			a[b].last[i]=0
		end
	end
	a[b].deltaVar=(c-a[b].last[n])/n
	for i=100,2,-1 do
		a[b].last[i]=a[b].last[i-1]
	end
	a[b].last[1]=c
	return a[b].deltaVar
end

--ADVANCED DELTA minified
function delta(c,b,n)if not a then a={} a[b]={} a[b].deltaVar=0 a[b].last={} for i=1,100 do a[b].last[i]=0 end elseif not a[b] then a[b]={} a[b].deltaVar=0 a[b].last={} for i=1,100 do a[b].last[i]=0 end end a[b].deltaVar=(c-a[b].last[n])/n for i=100,2,-1 do a[b].last[i]=a[b].last[i-1] end a[b].last[1]=c return a[b].deltaVar end

--example (for Pony IDE)
howManyTicksBackInTime = 5
x = x + 1
print(delta(x, "customKey", howManyTicksBackInTime)) --prints: 1
y = y + 0.69
print(delta(y, "customKey2", howManyTicksBackInTime)) --prints: 0.69

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Next

--VARIABLE TIME ROLLING AVERAGE
--takes the delta of input over ticks ticks
--VARIABLE TIME ROLLING AVERAGE unminified
function vRollAvg(input,ticks,spot)
    if not varRollAvgTable then
        varRollAvgTable = {}
        varRollAvgTable[spot] = {avgTable = {},result = 0,ticks = 0,sum = 0}
    elseif not varRollAvgTable[spot] then
        varRollAvgTable[spot] = {avgTable = {},result = 0,ticks = 0,sum = 0}
    end
    if ticks<2 then 
        varRollAvgTable[spot].ticks=2
    else
        varRollAvgTable[spot].ticks=ticks
    end
    table.insert(varRollAvgTable[spot].avgTable,input)
    if #varRollAvgTable[spot].avgTable > varRollAvgTable[spot].ticks then
        table.remove(varRollAvgTable[spot].avgTable,1)
    end
    varRollAvgTable[spot].sum=0
    for key,value in pairs(varRollAvgTable[spot].avgTable) do
        varRollAvgTable[spot].sum=varRollAvgTable[spot].sum+value
    end
    varRollAvgTable[spot].result=varRollAvgTable[spot].sum/#varRollAvgTable[spot].avgTable
    return varRollAvgTable[spot].result
end

--VARIABLE TIME ROLLING AVERAGE minified
function vRollAvg(d,c,b)if not a then a={}a[b]={avgTable={},result=0,ticks=0,sum=0}elseif not a[b]then a[b]={avgTable={},result=0,ticks=0,sum=0}end;if c<2 then a[b].ticks=2 else a[b].ticks=c end;table.insert(a[b].avgTable,d)if#a[b].avgTable>a[b].ticks then table.remove(a[b].avgTable,1)end;a[b].sum=0;for h,f in pairs(a[b].avgTable)do a[b].sum=a[b].sum+f end;a[b].result=a[b].sum/#a[b].avgTable;return a[b].result end

--VARIABLE TIME ROLLING AVERAGE example
ticks=property.getNumber("ticks")
function onTick()
    var=input.getNumber(1)
    output.setNumber(1,vRollAvg(var,ticks,"customName"))
end




--template to add new functions below:
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Next

--
-- unminified


-- minified


-- example (for Pony IDE)








--template WITH explanation for this kind of structure below:

function functionName(input1,input2,spot) --as many inputs as are needed can be inputted. spot is required for this structure, the provided argument to spot must be in quotes
  if not bigTable then --if not variable is a way of checking if something exists, if it does not exist then it will return false. if the table that holds the tables with their variables doesn't exist:
    bigTable = {} --create it
    bigTable[spot] = {variable1=whatever,variable2=whatever} --create the table inside the main table with as many variables as we need to keep track of across runs, with whatever start values they should have
  elseif not bigTable[spot] then --if the table that holds variables at the spot provided does not exist:
    bigTable[spot] = {variable1=whatever,variable2=whatever} --the main table already exists so we don't create it, but we create our spot in it
  end
    --in place of this comment goes whatever code should run each time
    --To use the inputs to the function we just write what we called them when we defined the function, same as normal (in this case input1 and input2)
    --To use variables we created in the main table or want to save over time, we can do bigTable[spot].nameOfVariable and that way we will retrieve it at the spot this function was called with. In this case an example would be bigTable[spot].variable1

  return bigTable[spot].whateverWeWannaReturn --return whatever we saved that we want to return from this spot
end

and to use:
x = functionName(something,anotherThing,"whatever string as long as its surrounded by quotes and unique to this kind of function")

the first if not bigTable is needed for this to work at all, it needs to create the table and its insides at this spot
the elseif not bigTable[spot] is needed in case this function is used many places. Without it, the code might make bigTable and bigTable["thing number 1"] in it, but if we on a later line use the function with "thing number 2" as spot, it would see that bigTable already exists and not make bigTable or bigTable["thing number 2"], so it would error or do something strange

There are much smaller ways to do a similar thing, but that require you do x = makeThingObject() for each function over time you wanna use, which is not simple enough to use for me personally though its obviously preference



--template WITHOUT explanation for this kind of structure below:
function functionName(input1,input2,spot)
  if not bigTable then
    bigTable = {}
    bigTable[spot] = {variable1=whatever,variable2=whatever}
  elseif not bigTable[spot] then
    deltaTable[spot] = {variable1=whatever,variable2=whatever}
  end
    --in place of this comment goes whatever code should run each time
  return bigTable[spot].whateverWeWannaReturn
end



--thesavingdeath wrote the advanced delta function and the vector3 delta function!