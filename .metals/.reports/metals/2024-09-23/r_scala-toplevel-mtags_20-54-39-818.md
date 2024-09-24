error id: file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/top_core.scala:[61..68) in Input.VirtualFile("file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/top_core.scala", "package core
import chisel3._
import chisel3.util._


class  extends  Module {
  
  val io = IO(new Bundle {
    val wb_dataout = Output(UInt(32.W))
    val  wb_datamem_in =  Input(UInt(32.W))
    val   wb_alu_out =  Input(UInt(32.W))
    val ins =  Input(UInt(32.W)) 
  })


  io.wb_dataout:= Mux(io.ins(6,0)=== 3.U , io.wb_datamem_in,0.U)

}")
file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/top_core.scala
file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/top_core.scala:6: error: expected identifier; obtained extends
class  extends  Module {
       ^
#### Short summary: 

expected identifier; obtained extends