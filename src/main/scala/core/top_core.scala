package core
import chisel3._
import chisel3.util._


class top_core extends  Module {
  val io = IO(new Bundle{



  })

  
  // calling objects
  val fetch_module = Module(new fetch)
  val decode_module = Module(new decode)
  val execute_module = Module(new execute)
  val mem_module = Module(new mem)
  val wb_module = Module(new wb)

    // conections fetch and decode
    decode_module.io.decode_instruction := fetch_module.io.Imem_fetch_out
    decode_module.io.pc_fetch_to_deocde :=fetch_module.io.pc_fetch_out
   
   


    // decode and execute 
    execute_module.io.A_alu_execute := decode_module.io.decode_regf_rdata1
    execute_module.io.B_alu_execute := decode_module.io.decode_regf_rdata2
    execute_module.io.ins_execute := decode_module.io.decode_instruction
    execute_module.io.op_alu_execute := decode_module.io.decode_func3_7
    execute_module.io.imm_execute := decode_module.io.decode_imm_out

    // providing pc and imm to add it in execute
    execute_module.io.pc_fetch := fetch_module.io.pc_fetch_out
    execute_module.io.imm_decode := decode_module.io.decode_imm_out

    // reciving imm + pc from execute 
    fetch_module.io.pc_imm_execute := execute_module.io.pc_imm_added

    // connections between execute and mem
    


    











    // write back 
    decode_module.io.decode_regf_wdata  := wb_module.io.wb_dataout


}