package core
import chisel3._
import chisel3.tester._
import org.scalatest.FreeSpec
import chisel3.experimental.BundleLiterals._
class cutest extends FreeSpec with ChiselScalatestTester{
"Chisel Tester File cu" in {
    test(new controlunit){  a=>
a.io.instruction.poke(1.U)

 a.clock.step(2)
// a.io.rs1.expect(1.U)
// a.io.rs2.expect(2.U)
// a.io.rd.expect(3.U)
// // a.io.imm.expect(12.U)
// a.io.opcode.expect(51.U)
    
    }

}


}