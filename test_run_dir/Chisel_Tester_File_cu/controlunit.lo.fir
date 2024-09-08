circuit controlunit :
  module controlunit :
    input clock : Clock
    input reset : UInt<1>
    input io_instruction : UInt<32>
    output io_func3_7 : UInt<3>
    output io_en_imem : UInt<1>
    output io_en_reg : UInt<1>
    output io_rd : UInt<5>
    output io_rs2 : UInt<5>
    output io_rs1 : UInt<5>
    output io_imm : UInt<12>

    node _T = bits(io_instruction, 6, 0) @[controlunit.scala 20:20]
    node _T_1 = eq(_T, UInt<6>("h33")) @[controlunit.scala 20:26]
    node io_func3_7_hi = bits(io_instruction, 30, 30) @[controlunit.scala 22:35]
    node io_func3_7_lo = bits(io_instruction, 14, 12) @[controlunit.scala 22:54]
    node _io_func3_7_T = cat(io_func3_7_hi, io_func3_7_lo) @[Cat.scala 30:58]
    node _T_2 = bits(io_instruction, 6, 0) @[controlunit.scala 24:26]
    node _T_3 = eq(_T_2, UInt<5>("h13")) @[controlunit.scala 24:32]
    node _io_func3_7_T_1 = bits(io_instruction, 14, 12) @[controlunit.scala 26:33]
    node _T_4 = bits(io_instruction, 14, 12) @[controlunit.scala 27:24]
    node _T_5 = eq(_T_4, UInt<3>("h5")) @[controlunit.scala 27:33]
    node io_func3_7_hi_1 = bits(io_instruction, 30, 30) @[controlunit.scala 29:39]
    node io_func3_7_lo_1 = bits(io_instruction, 14, 12) @[controlunit.scala 29:58]
    node _io_func3_7_T_2 = cat(io_func3_7_hi_1, io_func3_7_lo_1) @[Cat.scala 30:58]
    node _GEN_0 = mux(_T_5, _io_func3_7_T_2, _io_func3_7_T_1) @[controlunit.scala 28:5 controlunit.scala 29:18 controlunit.scala 26:16]
    node _T_6 = bits(io_instruction, 6, 0) @[controlunit.scala 32:26]
    node _T_7 = eq(_T_6, UInt<2>("h3")) @[controlunit.scala 32:32]
    node _io_func3_7_T_3 = bits(io_instruction, 14, 12) @[controlunit.scala 34:33]
    node _T_8 = bits(io_instruction, 6, 0) @[controlunit.scala 36:26]
    node _T_9 = eq(_T_8, UInt<6>("h23")) @[controlunit.scala 36:32]
    node _io_func3_7_T_4 = bits(io_instruction, 14, 12) @[controlunit.scala 38:33]
    node _T_10 = bits(io_instruction, 6, 0) @[controlunit.scala 40:26]
    node _T_11 = eq(_T_10, UInt<7>("h6f")) @[controlunit.scala 40:32]
    node _GEN_1 = mux(_T_11, UInt<1>("h1"), UInt<1>("h0")) @[controlunit.scala 40:44 controlunit.scala 41:13 controlunit.scala 17:11]
    node _GEN_2 = mux(_T_9, _io_func3_7_T_4, UInt<1>("h0")) @[controlunit.scala 37:1 controlunit.scala 38:16 controlunit.scala 18:12]
    node _GEN_3 = mux(_T_9, UInt<1>("h0"), _GEN_1) @[controlunit.scala 37:1 controlunit.scala 39:15]
    node _GEN_4 = mux(_T_7, _io_func3_7_T_3, _GEN_2) @[controlunit.scala 33:1 controlunit.scala 34:16]
    node _GEN_5 = mux(_T_7, UInt<1>("h1"), _GEN_3) @[controlunit.scala 33:1 controlunit.scala 35:15]
    node _GEN_6 = mux(_T_3, _GEN_0, _GEN_4) @[controlunit.scala 25:1]
    node _GEN_7 = mux(_T_3, UInt<1>("h1"), _GEN_5) @[controlunit.scala 25:1 controlunit.scala 31:15]
    node _GEN_8 = mux(_T_1, _io_func3_7_T, _GEN_6) @[controlunit.scala 21:1 controlunit.scala 22:14]
    node _GEN_9 = mux(_T_1, UInt<1>("h1"), _GEN_7) @[controlunit.scala 21:1 controlunit.scala 23:13]
    node _io_rd_T = bits(io_instruction, 11, 7) @[controlunit.scala 44:25]
    node _io_rs1_T = bits(io_instruction, 19, 15) @[controlunit.scala 45:26]
    node _io_rs2_T = bits(io_instruction, 24, 20) @[controlunit.scala 46:26]
    node _io_imm_T = bits(io_instruction, 31, 20) @[controlunit.scala 47:26]
    io_func3_7 <= bits(_GEN_8, 2, 0)
    io_en_imem <= UInt<1>("h0") @[controlunit.scala 16:12]
    io_en_reg <= _GEN_9
    io_rd <= _io_rd_T @[controlunit.scala 44:8]
    io_rs2 <= _io_rs2_T @[controlunit.scala 46:9]
    io_rs1 <= _io_rs1_T @[controlunit.scala 45:9]
    io_imm <= _io_imm_T @[controlunit.scala 47:9]
