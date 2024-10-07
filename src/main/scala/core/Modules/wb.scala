package core
import chisel3._
import chisel3.util._


class wb extends  Module {
  
  val io = IO(new Bundle {
    val wb_dataout = Output(UInt(32.W))
    val  wb_datamem_out =  Input(UInt(32.W))
    val   wb_alu_out =  Input(UInt(32.W))
    val ins =  Input(UInt(32.W)) 
  })



  io.wb_dataout:= Mux(io.ins(6,0)=== "h3".U , io.wb_datamem_out,io.wb_alu_out)

}