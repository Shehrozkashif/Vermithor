;buildInfoPackage: chisel3, version: 3.4.3, scalaVersion: 2.12.12, sbtVersion: 1.3.10
circuit controlunit : 
  module controlunit : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip instruction : UInt<32>, func3_7 : UInt<3>, en_imem : UInt<1>, en_reg : UInt<1>, rd : UInt<5>, rs2 : UInt<5>, rs1 : UInt<5>, imm : UInt<12>}
    
    io.en_imem <= UInt<1>("h00") @[controlunit.scala 16:12]
    io.en_reg <= UInt<1>("h00") @[controlunit.scala 17:11]
    io.func3_7 <= UInt<1>("h00") @[controlunit.scala 18:12]
    node _T = bits(io.instruction, 6, 0) @[controlunit.scala 20:20]
    node _T_1 = eq(_T, UInt<6>("h033")) @[controlunit.scala 20:26]
    when _T_1 : @[controlunit.scala 21:1]
      node io_func3_7_hi = bits(io.instruction, 30, 30) @[controlunit.scala 22:35]
      node io_func3_7_lo = bits(io.instruction, 14, 12) @[controlunit.scala 22:54]
      node _io_func3_7_T = cat(io_func3_7_hi, io_func3_7_lo) @[Cat.scala 30:58]
      io.func3_7 <= _io_func3_7_T @[controlunit.scala 22:14]
      io.en_reg <= UInt<1>("h01") @[controlunit.scala 23:13]
      skip @[controlunit.scala 21:1]
    else : @[controlunit.scala 25:1]
      node _T_2 = bits(io.instruction, 6, 0) @[controlunit.scala 24:26]
      node _T_3 = eq(_T_2, UInt<5>("h013")) @[controlunit.scala 24:32]
      when _T_3 : @[controlunit.scala 25:1]
        node _io_func3_7_T_1 = bits(io.instruction, 14, 12) @[controlunit.scala 26:33]
        io.func3_7 <= _io_func3_7_T_1 @[controlunit.scala 26:16]
        node _T_4 = bits(io.instruction, 14, 12) @[controlunit.scala 27:24]
        node _T_5 = eq(_T_4, UInt<3>("h05")) @[controlunit.scala 27:33]
        when _T_5 : @[controlunit.scala 28:5]
          node io_func3_7_hi_1 = bits(io.instruction, 30, 30) @[controlunit.scala 29:39]
          node io_func3_7_lo_1 = bits(io.instruction, 14, 12) @[controlunit.scala 29:58]
          node _io_func3_7_T_2 = cat(io_func3_7_hi_1, io_func3_7_lo_1) @[Cat.scala 30:58]
          io.func3_7 <= _io_func3_7_T_2 @[controlunit.scala 29:18]
          skip @[controlunit.scala 28:5]
        io.en_reg <= UInt<1>("h01") @[controlunit.scala 31:15]
        skip @[controlunit.scala 25:1]
      else : @[controlunit.scala 33:1]
        node _T_6 = bits(io.instruction, 6, 0) @[controlunit.scala 32:26]
        node _T_7 = eq(_T_6, UInt<2>("h03")) @[controlunit.scala 32:32]
        when _T_7 : @[controlunit.scala 33:1]
          node _io_func3_7_T_3 = bits(io.instruction, 14, 12) @[controlunit.scala 34:33]
          io.func3_7 <= _io_func3_7_T_3 @[controlunit.scala 34:16]
          io.en_reg <= UInt<1>("h01") @[controlunit.scala 35:15]
          skip @[controlunit.scala 33:1]
        else : @[controlunit.scala 37:1]
          node _T_8 = bits(io.instruction, 6, 0) @[controlunit.scala 36:26]
          node _T_9 = eq(_T_8, UInt<6>("h023")) @[controlunit.scala 36:32]
          when _T_9 : @[controlunit.scala 37:1]
            node _io_func3_7_T_4 = bits(io.instruction, 14, 12) @[controlunit.scala 38:33]
            io.func3_7 <= _io_func3_7_T_4 @[controlunit.scala 38:16]
            io.en_reg <= UInt<1>("h00") @[controlunit.scala 39:15]
            skip @[controlunit.scala 37:1]
          else : @[controlunit.scala 40:44]
            node _T_10 = bits(io.instruction, 6, 0) @[controlunit.scala 40:26]
            node _T_11 = eq(_T_10, UInt<7>("h06f")) @[controlunit.scala 40:32]
            when _T_11 : @[controlunit.scala 40:44]
              io.en_reg <= UInt<1>("h01") @[controlunit.scala 41:13]
              skip @[controlunit.scala 40:44]
    node _io_rd_T = bits(io.instruction, 11, 7) @[controlunit.scala 44:25]
    io.rd <= _io_rd_T @[controlunit.scala 44:8]
    node _io_rs1_T = bits(io.instruction, 19, 15) @[controlunit.scala 45:26]
    io.rs1 <= _io_rs1_T @[controlunit.scala 45:9]
    node _io_rs2_T = bits(io.instruction, 24, 20) @[controlunit.scala 46:26]
    io.rs2 <= _io_rs2_T @[controlunit.scala 46:9]
    node _io_imm_T = bits(io.instruction, 31, 20) @[controlunit.scala 47:26]
    io.imm <= _io_imm_T @[controlunit.scala 47:9]
    
