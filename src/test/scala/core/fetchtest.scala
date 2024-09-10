package core
import chisel3._
import chisel3.tester._
import org.scalatest.FreeSpec
import chisel3.experimental.BundleLiterals._
class fetchtest extends FreeSpec with ChiselScalatestTester{
"Chisel Tester File fetchtest" in {
    test(new fetch){  a=>
   
    a.clock.step(20)
    // a.io.output.expect(104.U)
    }

}
}