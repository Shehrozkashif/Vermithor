package core
import chisel3._
import chisel3.util._


class fetch extends Module{
val io = IO(new Bundle{

    val A_alu_execute = Input(UInt(32.W))
    val B_alu_execute = Input(UInt(32.W))
    val op_alu_execute = Input(UInt(4.W))
    val out_alu_execute = Output(UInt(32.W))


  } )  



    // calling the objects 
    val alumod = Module(new alu)



    // connections between alu and execute stage
    alumod.io.A := io.A_alu_execute
    alumod.io.B := io.B_alu_execute
    alumod.io.op := io.op_alu_execute
    io.out_alu_execute := alumod.io.out 







    
    



}