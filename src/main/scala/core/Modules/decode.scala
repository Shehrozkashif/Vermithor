package core
import chisel3._
import chisel3.util._


class decode extends Module{
val io = IO(new Bundle{
    // control unit inputs and outputs
    val decode_instruction = Input(UInt(32.W))
    val decode_func3_7 = Output(UInt(4.W))
    // val decode_en_imem = Output(Bool())  // imem enable


    // immediate generator inputs and outputs
    val decode_imm_out = Output(UInt(32.W))


    // register_file inputs and outputs
    val decode_regf_rdata1 = Output ( UInt ( 32 . W ) ) //rs1 output
    val decode_regf_rdata2 = Output ( UInt ( 32 . W ) ) //rs2 output
   
    val decode_regf_wdata = Input(UInt(32.W)) // writing back from wb stage in regf

  } ) 


// making instances
    val cumod = Module(new controlunit)
    val immgmod = Module(new immgenr)
    val regfmod = Module(new registerfile)


    // taking instruction from fetch assigning to cu
    cumod.io.instruction := io.decode_instruction


    // taking fun 3 from cu to give execute
    io.decode_func3_7 := cumod.io.func3_7
  
   
    // connections between immediate generation and decode
    immgmod.io.instruction:=io.decode_instruction
    io.decode_imm_out := immgmod.io.imm


    // connections between register file and control unit
    regfmod.io.raddr1 := cumod.io.rs1
    regfmod.io.raddr2 := cumod.io.rs2
    regfmod.io.wen := cumod.io.en_reg
    regfmod.io.waddr := cumod.io.rd


    // connections between register file and decode stage
    io.decode_regf_rdata1 := regfmod.io.rdata1
    io.decode_regf_rdata2 := regfmod.io.rdata2
    regfmod.io.wdata := io.decode_regf_wdata 
    

}