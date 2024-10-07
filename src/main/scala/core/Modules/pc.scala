package core
import chisel3._
import chisel3.util._


class pc extends Module{
val io = IO(new Bundle{


  val imm = Input(UInt(32.W))
  val out = Output(UInt(32.W))
  val jump = Input(Bool())     // Branch
 
  // val rs1data =Input(UInt(32.W))

  
  } )
  io.out := 0.U
  val max = 1024.U
  val pc = RegInit(0.U(32.W) ) 

when(io.jump){  // branch
pc :=  io.imm
}
.otherwise{
pc := pc  + 4.U
}

io.out := pc

}