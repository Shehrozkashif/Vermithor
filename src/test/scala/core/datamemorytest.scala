// package core
// import chisel3._
// import chisel3.tester._
// import org.scalatest.FreeSpec
// import chisel3.experimental.BundleLiterals._
// class datamemorytest extends FreeSpec with ChiselScalatestTester{
// "Chisel Tester File mem" in {
//     test(new datamemory){  a=>
// a.io.dataIn.poke(0.U)
// a.io.wr_enable.poke(0.B)
// a.io.rd_enable.poke(0.B)
// a.clock.step(1)
// a.io.out.expect(0.B)
//     }
// }
// }