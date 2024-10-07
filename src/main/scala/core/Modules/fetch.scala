package core
import chisel3._
import chisel3.util._


class fetch extends Module{
val io = IO(new Bundle{
    //pc_inputs and outputs
    val pc_fetch_out = Output(UInt(32.W))
    
    
    // instruction memory inputs and outputs
    // val Imem_fetch_enable  = Input(Bool()) // check
    val Imem_fetch_out = Output(UInt(32.W))


    // pc + imm
    // reciving imm from execute 
    val pc_imm_execute = Input(UInt(32.W))

    // catching jump from execute 
     val jump_fetch = Input(Bool()) 




  } )  

   // making instances
    val pcmod = Module(new pc)
    val inmmod = Module(new Imem)



    
   


    // connections between  instruction memory and pc
    inmmod.io.address := pcmod.io.out


    // connections between pc and fetch_module inputs
    pcmod.io.imm := io.pc_imm_execute
   

    
    // connections between pc and fetch_module outputs
    io.pc_fetch_out := pcmod.io.out 


     // connections between instruction and fetch_module inputs
    io.Imem_fetch_out := inmmod.io.out 

        // jump
        pcmod.io.jump := io.jump_fetch
   
}