package core
import chisel3._
import chisel3.util._


class topcore extends  Module {
  val io = IO(new Bundle{

     val out = Output(UInt(32.W))

  })

  
  // calling objects
  val fetch_module = Module(new fetch)
  val decode_module = Module(new decode)
  val execute_module = Module(new execute)
  val mem_module = Module(new mem)
  val wb_module = Module(new wb)

  

    // conections fetch and decode
    decode_module.io.decode_instruction := fetch_module.io.Imem_fetch_out
    execute_module.io.pc_fetch := fetch_module.io.pc_fetch_out // sending pc to add with imm
    // reciving imm + pc from execute 
    fetch_module.io.pc_imm_execute := execute_module.io.pc_imm_added
    
   
   


    // decode and execute 
    execute_module.io.A_alu_execute := decode_module.io.decode_regf_rdata1
    execute_module.io.B_alu_execute := decode_module.io.decode_regf_rdata2
    execute_module.io.ins_execute := decode_module.io.decode_instruction
    execute_module.io.op_alu_execute := decode_module.io.decode_func3_7
    execute_module.io.imm_execute := decode_module.io.decode_imm_out

    
    // providing pc and imm to add it in execute
    execute_module.io.imm_execute := decode_module.io.decode_imm_out



    // connections between execute and mem
    mem_module.io.datain_mem := execute_module.io.out_alu_execute

    //  execute and mem and wb conncections
    wb_module.io.wb_datamem_out := mem_module.io.out_mem
    wb_module.io.wb_alu_out := execute_module.io.out_alu_execute

    // write back 
    decode_module.io.decode_regf_wdata  := wb_module.io.wb_dataout

    mem_module.io.wr_enable_mem := false.B // Default to false
    mem_module.io.rd_enable_mem := false.B // Default to false
    mem_module.io.addr_mem := 0.U // Default to 

    wb_module.io.ins := fetch_module.io.Imem_fetch_out



    // write back
    io.out := wb_module.io.wb_dataout


    // jump 
    fetch_module.io.jump_fetch :=  execute_module.io.jump_execute



    when(decode_module.io.decode_instruction(6,0) === "h6f".U){   //jal
     fetch_module.io.jump_fetch := 1.B
    decode_module.io.decode_regf_wdata := fetch_module.io.pc_fetch_out + 4.U

    }
    when(decode_module.io.decode_instruction(6,0) === "h67".U){   //jalr
     fetch_module.io.jump_fetch := 1.B
     decode_module.io.decode_regf_wdata := fetch_module.io.pc_fetch_out
      fetch_module.io.pc_imm_execute := decode_module.io.decode_regf_rdata1 + decode_module.io.decode_imm_out
}

    // uuper immeidate type code
    when(decode_module.io.decode_instruction(6,0) === "h37".U ){ // U type lui
    decode_module.io.decode_regf_wdata := decode_module.io.decode_imm_out
    print(decode_module.io.decode_imm_out)
    }
    when(decode_module.io.decode_instruction(6,0) === "h17".U ){ // U type auipc

    decode_module.io.decode_regf_wdata := decode_module.io.decode_imm_out + fetch_module.io.pc_fetch_out

    }



    // address calculation for store type
when(decode_module.io.decode_instruction(6,0) === "h23".U ){
 
 mem_module.io.wr_enable_mem  := 1.B

  mem_module.io.addr_mem := execute_module.io.out_alu_execute(9,2)

 
  when(decode_module.io.decode_instruction(14,12) === 0.U){  // Store Bytes
    mem_module.io.datain_mem  := decode_module.io.decode_regf_rdata2 (7,0)
    

  }.elsewhen(decode_module.io.decode_instruction(14,12) === 1.U){ // store halfword
        mem_module.io.datain_mem  := decode_module.io.decode_regf_rdata2 (15,0)

  
  }.elsewhen(decode_module.io.decode_instruction(14,12) === 2.U){  // store word 
        mem_module.io.datain_mem  := decode_module.io.decode_regf_rdata2 (31,0)
    
  }
  
}

    // load
    when(decode_module.io.decode_instruction(6,0) === "h3".U ){
  mem_module.io.addr_mem := execute_module.io.out_alu_execute(9,2)
  mem_module.io.rd_enable_mem := 1.B
    when(decode_module.io.decode_instruction(14,12) === "b000".U ){ // load byte


      decode_module.io.decode_regf_wdata := wb_module.io.wb_dataout(7,0)
    

    }.elsewhen(decode_module.io.decode_instruction(14,12) === "b001".U ){ // load half
            
      decode_module.io.decode_regf_wdata := wb_module.io.wb_dataout(15,0)



    }.elsewhen(decode_module.io.decode_instruction(14,12) === "b010".U ){ // load word
     decode_module.io.decode_regf_wdata := wb_module.io.wb_dataout(31,0)


    }.elsewhen(decode_module.io.decode_instruction(14,12) === "b100".U ){ // load byte un
      decode_module.io.decode_regf_wdata := wb_module.io.wb_dataout(7,0)
    


    }.elsewhen(decode_module.io.decode_instruction(14,12) === "b101".U ){ // load half
      
    decode_module.io.decode_regf_wdata := wb_module.io.wb_dataout(15,0)

    }

}


}
