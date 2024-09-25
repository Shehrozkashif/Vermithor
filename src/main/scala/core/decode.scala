package core
import chisel3._
import chisel3.util._


class decode extends Module{
val io = IO(new Bundle{
    // control unit inputs and outputs
    val decode_instruction = Input(UInt(32.W))
    val decode_func3_7 = Output(UInt(3.W))
    // val decode_en_imem = Output(Bool())  // imem enable
    val decode_en_reg = Output(Bool()) // reg enable
    val decode_rd = Output(UInt(5.W))
    val decode_rs2 = Output(UInt(5.W))
    val decode_rs1 = Output(UInt(5.W))
    val decode_imm = Output(UInt(12.W))


    // immediate generator inputs and outputs
    val decode_immgenr_instruction = Input(UInt(32.W))
    val decode_imm_out = Output(UInt(32.W))


    // register_file inputs and outputs
    val decode_regf_raddr1 = Input ( UInt (5. W ) ) // rs1 
    val decode_regf_raddr2 = Input ( UInt (5. W ) )  // rs2 
    val decode_regf_rdata1 = Output ( UInt ( 32 . W ) ) //rs1 output
    val decode_regf_rdata2 = Output ( UInt ( 32 . W ) ) //rs2 output
    val decode_regf_wen = Input ( Bool () ) // wenable input
    val decode_regf_waddr = Input ( UInt (5. W ) )  //rd
    val decode_regf_wdata = Input ( UInt ( 32 . W ) ) // rd data

    // pcout
     val pc_fetch_to_deocde = Input(UInt(32.W))
     val pc_fetch_to_decode_out = Output(UInt(32.W))  


    // pc + imm
    val pc_imm_execute_to_decode = Input(UInt(32.W))
    val pc_imm_execute_to_decode_out = Output(UInt(32.W)) 



  } )  


    // making instances
    val cumod = Module(new controlunit)
    val immgmod = Module(new immgenr)
    val regfmod = Module(new registerfile)

    // connections between controlunit and decode 
    cumod.io.instruction := io.decode_instruction
    io.decode_func3_7 := cumod.io.func3_7
    // io.decode_en_imem := cumod.io.imem
    io.decode_en_reg  := cumod.io.en_reg
    io.decode_rd := cumod.io.rd
    io.decode_rs2 := cumod.io.rs2
    io.decode_rs1 := cumod.io.rs1
    io.decode_imm := cumod.io.imm


    // connections between immediate generation and decode
    immgmod.io.instruction:=io.decode_immgenr_instruction
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
    

    
    // pc 
    io.pc_fetch_to_decode_out := io.pc_fetch_to_deocde


    // pc + imm
    io.pc_imm_execute_to_decode_out :=io.pc_imm_execute_to_decode



}