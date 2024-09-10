package core
import chisel3._
import chisel3.util._


class fetch extends Module{
val io = IO(new Bundle{
    //pc_inputs and outputs
    val pc_fetch_imm = Input(UInt(32.W))
    val pc_fetch_out = Output(UInt(32.W))
    val pc_fetch_jump = Input(Bool())     // Branch
    val pc_fetch_jump2 = Input(Bool())    // Jal
    val pc_fetch_jump3 = Input(Bool())  // Jalr
    // val pc_fetch_rs1data =Input(UInt(32.W))


    // instruction memory inputs and outputs
    val Imem_fetch_enable  = Input(Bool()) // check
    val Imem_fetch_address = Input(UInt(32.W))
    val Imem_fetch_out = Output(UInt(32.W))


  } )
  

    
    

    // making instances
    val pcmod = Module(new pc)
    val inmmod = Module(new Imem)


    // connections between  instruction memory and pc
    inmmod.io.address := pcmod.io.out


    // connections between pc and fetch_module inputs
    pcmod.io.imm := io.pc_fetch_imm 
    pcmod.io.jump := io.pc_fetch_jump
    pcmod.io.jump2 := io.pc_fetch_jump2
    pcmod.io.jump3 := io.pc_fetch_jump3


    // connections between pc and fetch_module outputs
    io.pc_fetch_out := pcmod.io.out 


     // connections between instruction and fetch_module inputs
    inmmod.io.enable := io.Imem_fetch_enable
    inmmod.io.address := io.Imem_fetch_address
    io.Imem_fetch_out    := inmmod.io.out 





     




    






}