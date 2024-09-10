package core
import chisel3._
import chisel3.tester._
import org.scalatest.FreeSpec
import chisel3.experimental.BundleLiterals._
class memtest extends FreeSpec with ChiselScalatestTester{
"Chisel Tester File mem" in {
    test(new Imem){  a=>
// a.io.data_in.poke(0.U)
// a.io.enable.poke(0.B)
a.clock.step(0)
// a.io.out.expect(0.B)
    }
}
}