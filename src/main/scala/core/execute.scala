package core
import chisel3._
import chisel3.util._


class execute extends Module{
val io = IO(new Bundle{

    val A_alu_execute = Input(UInt(32.W))
    val B_alu_execute = Input(UInt(32.W))
    val op_alu_execute = Input(UInt(4.W))
    val out_alu_execute = Output(UInt(32.W))
    val ins_execute = Input(UInt(32.W))
    val imm_execute = Input(UInt(32.W))
    val regfrdata2_execute = Input(UInt(32.W))


    // pcout 
     val pc_decode_to_execute = Input(UInt(32.W))
     val pc_decode_to_execute_imm = Input(UInt(32.W))
     val pc_imm_execute_to_decode_out = Output(UInt(32.W)) 

     // pc + imm
    val imm_decode = Input(UInt(32.W))
    val pc_fetch = Input(UInt(32.W)) 
    val pc_imm_added = Output(UInt(32.W)) 


    


  } )  



    // calling the objects 
    val alumod = Module(new alu)



    // connections between alu and execute stage

    alumod.io.B := io.B_alu_execute
    alumod.io.op := io.op_alu_execute
    io.out_alu_execute := alumod.io.out 


    


    when(io.ins_execute (6,0) === "h13".U ){ // if I type instruction
    alumod.io.B := io.imm_execute
    }
    .otherwise{
    alumod.io.A := io.regfrdata2_execute
    }

    //pcout
    io.pc_imm_added  :=  io.imm_decode + io.pc_fetch
    

}