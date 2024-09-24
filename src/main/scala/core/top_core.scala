package core
import chisel3._
import chisel3.util._


class top_core extends  Module {

  
  // calling objects
  val fetch_module = Module(new fetch)
  val decode_module = Module(new decode)
  val execute_module = Module(new execute)
  val mem_module = Module(new mem)
  val wb_module = Module(new wb)

    // conections fetch and decode
    decode_module.io.decode_instruction := fetch_module.io.Imem_fetch_out

    // decode and execute 
    execute_module.io.A_alu_execute := decode_module.io.decode_regf_rdata1
    execute_module.io.B_alu_execute := decode_module.io.decode_regf_rdata2
    execute_module.io.ins_execute := decode_module.io.decode_instruction
    execute_module.io.op_alu_execute := decode_module.io.decode_func3_7
    execute_module.io.imm_execute := decode_module.io.decode_imm_out
    execute_module.io.regfrdata2_execute := decode_module.io.decode_regf_rdata2
    


    
}