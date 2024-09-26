package core
import chisel3._
import chisel3.tester._
import org.scalatest.FreeSpec
import chisel3.experimental.BundleLiterals._
class topcoretest extends FreeSpec with ChiselScalatestTester{
"Chisel Tester File topcoretest" in {
    test(new topcore){  a=>
   
    a.clock.step(200)
    // a.io.output.expect(104.U)
    }

}
}