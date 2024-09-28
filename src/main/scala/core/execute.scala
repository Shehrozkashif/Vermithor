package core
import chisel3._
import chisel3.util._


class execute extends Module{
val io = IO(new Bundle{

    val A_alu_execute = Input(UInt(32.W)) // rs1  out
    val B_alu_execute = Input(UInt(32.W)) // rs2  out
    val op_alu_execute = Input(UInt(4.W))
    val out_alu_execute = Output(UInt(32.W))
    val ins_execute = Input(UInt(32.W))
    val imm_execute = Input(UInt(32.W))


    // jump sending to fetch

     val jump_execute = Output(Bool()) 
    

     // pc + imm
    val pc_fetch = Input(UInt(32.W))  // pc value from fetch
    val pc_imm_added = Output(UInt(32.W)) // pc+imm out


  } )  
    io.jump_execute := 0.B


    // calling the objects 
    val alumod = Module(new alu)
    alumod.io.B := 0.U


    // connections between alu and execute stage
    alumod.io.A := io.A_alu_execute
    alumod.io.op := io.op_alu_execute
    io.out_alu_execute := alumod.io.out 


    when(io.ins_execute (6,0) === "h33".U ){ // R type 
    alumod.io.B := io.B_alu_execute
    }
    .elsewhen(io.ins_execute (6,0) === "h13".U){  // I type
    alumod.io.B := io.imm_execute
    }


    // branch type instruction 
when(io.ins_execute (6,0) === 99.U) {
  // alumod.io.op:= 0.U
  // alumod.io.A := pcmod.io.out
  alumod.io.B := io.imm_execute
  // dmmod.io.wr_enable := 1.B

  // dmmod.io.addr := alumod.io.out(9,2)

    // pcmod.io.imm := alumod.io.out
    when(io.ins_execute(14, 12) === 0.U) { // beq
      when(io.A_alu_execute === io.B_alu_execute) {
        io.jump_execute := true.B
      }
    }.elsewhen(io.ins_execute(14, 12) === 1.U) { // bne
      when(io.A_alu_execute =/= io.B_alu_execute) {
        io.jump_execute := true.B
      }
    }.elsewhen(io.ins_execute(14, 12) === 2.U) { // blt
      when(io.A_alu_execute < io.B_alu_execute) {
        io.jump_execute := true.B
      }
    }.elsewhen(io.ins_execute(14, 12) === 3.U) { // bge
      when(io.A_alu_execute >= io.B_alu_execute) {
        io.jump_execute := true.B
      }
    }.elsewhen(io.ins_execute(14, 12) === 4.U) { // bltu
      when(io.A_alu_execute.asUInt < io.B_alu_execute.asUInt()) {
        io.jump_execute := true.B
      }
    }.elsewhen(io.ins_execute(14, 12) === 5.U) { // bgeu
      when(io.A_alu_execute.asUInt >= io.B_alu_execute.asUInt()) {
        io.jump_execute := true.B
      }
    }

  }


    

    
    











































































    //pcout
    io.pc_imm_added  :=  io.imm_execute + io.pc_fetch
    

}