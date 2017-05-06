import os
import sys

#Global Variables
num_reg_bits = 2

#Functions

def reg_is_valid(reg):
    if len(reg) == 4 + num_reg_bits and reg[0:4] == "$reg" and reg[-num_reg_bits:].isdigit():
        return True
    return False

def assembly_instruction_is_valid(assembly_instruction):
    if assembly_instruction.startswith("lui "):
        dest_reg = assembly_instruction[4:10]
        if not reg_is_valid(dest_reg):
            return False
        space = assembly_instruction[10]
        if not space.isspace():
            return False
        immediate = assembly_instruction[11:]
        if len(immediate) != 4 or (not immediate.isdigit()):
            return False
    elif assembly_instruction.startswith("add ") \
         or assembly_instruction.startswith("sub "): 
        reg1 = assembly_instruction[4:10]
        if not reg_is_valid(reg1):
            return False
        space = assembly_instruction[10]
        if not space.isspace():
            return False
        reg2 = assembly_instruction[11:17]
        if not reg_is_valid(reg2):
            return False
        space = assembly_instruction[17]
        if not space.isspace():
            return False
        reg_res = assembly_instruction[18:]
        if not reg_is_valid(reg_res):
            return False
    elif assembly_instruction.startswith("prt "):
        reg_to_prt = assembly_instruction[4:]
        if not reg_is_valid(reg_to_prt):
            print "*"
            return False
    elif assembly_instruction.startswith("cmp "):
        reg1 = assembly_instruction[4:10]
        if not reg_is_valid(reg1):
            return False
        space = assembly_instruction[10]
        if not space.isspace():
            return False
        reg2 = assembly_instruction[11:17]
        if not reg_is_valid(reg2):
            return False
        space = assembly_instruction[17]
        if not space.isspace():
            return False
        one_or_two = assembly_instruction[18:]
        if not (one_or_two == "1" or one_or_two == "2"):
            return False
    else:
        return False
    return True

def reg_bits(reg):
    #The last two characters of a reg name are the reg's address bits
    return reg[-num_reg_bits:]

def assemble(assembly_filename, dest_dir):
    if assembly_filename[-4:] != ".txt":
        print assembly_filename[-4:]
        raise Exception("Filename must be a .txt file")
    with open(assembly_filename, 'r') as assembly_file, \
         open(os.path.join(dest_dir, os.path.basename(os.path.normpath(assembly_filename))[:-4] + "_machine_code.txt"), 'w') as machine_code_file:
        for assembly_instruction in assembly_file:
            assembly_instruction = assembly_instruction[:-1]
            print assembly_instruction
            if not assembly_instruction_is_valid(assembly_instruction):
                raise Exception("Assembly instruction invalid")
            machine_code_instruction = ""
            if assembly_instruction.startswith("lui "):
                dest_reg = assembly_instruction[4:10]
                dest_reg_bits = reg_bits(dest_reg)
                immediate = assembly_instruction[11:]
                machine_code_instruction = "00" + dest_reg_bits \
                                           + immediate
            elif assembly_instruction.startswith("add ") \
                 or assembly_instruction.startswith("sub "): 
                opcode = ""
                if assembly_instruction.startswith("add "):
                    opcode = "01"
                else:
                    opcode = "10"
                reg1 = assembly_instruction[4:10]
                reg1_bits = reg_bits(reg1)
                reg2 = assembly_instruction[11:17]
                reg2_bits = reg_bits(reg2)
                reg_res = assembly_instruction[18:]
                reg_res_bits = reg_bits(reg_res)
                machine_code_instruction = opcode + reg1_bits \
                                           + reg2_bits + reg_res_bits
            elif assembly_instruction.startswith("prt "):
                reg_to_prt = assembly_instruction[4:]
                reg_to_prt_bits = reg_bits(reg_to_prt)
                machine_code_instruction = "110" + reg_to_prt_bits + "000"
            elif assembly_instruction.startswith("cmp "):
                reg1 = assembly_instruction[4:10]
                reg1_bits = reg_bits(reg1)
                reg2 = assembly_instruction[11:17]
                reg2_bits = reg_bits(reg2)
                one_or_two = assembly_instruction[18:]
                one_or_two_bit = ""
                if one_or_two == "1":
                    one_or_two_bit = "0"
                else:
                    one_or_two_bit = "1"
                machine_code_instruction = "111" + reg1_bits + reg2_bits \
                                           + one_or_two_bit
            else:
                raise Exception("The assembly_instruction_is_valid function is faulty")
            machine_code_instruction += "\n"
            machine_code_file.write(machine_code_instruction)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print "Arguments you supplied: " + str(sys.argv)
        print "You supplied " + str(len(sys.argv)) + " arguments."
        print "You need to supply the assembly instructions filename and destination directory."
        sys.exit()
    assembly_instructions_filename = sys.argv[1]
    dest_dir = sys.argv[2]
    assemble(assembly_instructions_filename, dest_dir)