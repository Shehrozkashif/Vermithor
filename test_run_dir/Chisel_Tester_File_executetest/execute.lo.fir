circuit execute :
  module alu :
    input clock : Clock
    input reset : UInt<1>
    input io_A : UInt<32>
    input io_B : UInt<32>
    input io_op : UInt<4>
    output io_out : UInt<32>

    node shiftamount = bits(io_B, 4, 0) @[alu.scala 28:25]
    node _T = eq(UInt<4>("h0"), io_op) @[Conditional.scala 37:30]
    node _io_out_T = add(io_A, io_B) @[alu.scala 32:22]
    node _io_out_T_1 = tail(_io_out_T, 1) @[alu.scala 32:22]
    node _T_1 = eq(UInt<4>("h8"), io_op) @[Conditional.scala 37:30]
    node _io_out_T_2 = sub(io_A, io_B) @[alu.scala 35:22]
    node _io_out_T_3 = tail(_io_out_T_2, 1) @[alu.scala 35:22]
    node _T_2 = eq(UInt<4>("h7"), io_op) @[Conditional.scala 37:30]
    node _io_out_T_4 = and(io_A, io_B) @[alu.scala 38:22]
    node _T_3 = eq(UInt<4>("h6"), io_op) @[Conditional.scala 37:30]
    node _io_out_T_5 = or(io_A, io_B) @[alu.scala 41:22]
    node _T_4 = eq(UInt<4>("h4"), io_op) @[Conditional.scala 37:30]
    node _io_out_T_6 = xor(io_A, io_B) @[alu.scala 44:22]
    node _T_5 = eq(UInt<4>("h2"), io_op) @[Conditional.scala 37:30]
    node _T_6 = lt(io_A, io_B) @[alu.scala 47:18]
    node _GEN_0 = mux(_T_6, UInt<1>("h1"), UInt<1>("h0")) @[alu.scala 47:26 alu.scala 48:16 alu.scala 29:10]
    node _T_7 = eq(UInt<4>("h1"), io_op) @[Conditional.scala 37:30]
    node _io_out_T_7 = dshl(io_A, shiftamount) @[alu.scala 52:22]
    node _T_8 = eq(UInt<4>("h3"), io_op) @[Conditional.scala 37:30]
    node _T_9 = lt(io_A, io_B) @[alu.scala 58:18]
    node _GEN_1 = mux(_T_9, UInt<1>("h1"), UInt<1>("h0")) @[alu.scala 58:25 alu.scala 59:16 alu.scala 29:10]
    node _T_10 = eq(UInt<4>("h5"), io_op) @[Conditional.scala 37:30]
    node _io_out_T_8 = dshr(io_A, shiftamount) @[alu.scala 66:22]
    node _T_11 = eq(UInt<4>("hd"), io_op) @[Conditional.scala 37:30]
    node _io_out_T_9 = asSInt(io_A) @[alu.scala 69:17]
    node _io_out_T_10 = dshr(_io_out_T_9, shiftamount) @[alu.scala 69:23]
    node _io_out_T_11 = asUInt(_io_out_T_10) @[alu.scala 69:38]
    node _GEN_2 = mux(_T_11, _io_out_T_11, UInt<1>("h0")) @[Conditional.scala 39:67 alu.scala 69:9 alu.scala 29:10]
    node _GEN_3 = mux(_T_10, _io_out_T_8, _GEN_2) @[Conditional.scala 39:67 alu.scala 66:15]
    node _GEN_4 = mux(_T_8, _GEN_1, _GEN_3) @[Conditional.scala 39:67]
    node _GEN_5 = mux(_T_7, _io_out_T_7, _GEN_4) @[Conditional.scala 39:67 alu.scala 52:14]
    node _GEN_6 = mux(_T_5, _GEN_0, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_7 = mux(_T_4, _io_out_T_6, _GEN_6) @[Conditional.scala 39:67 alu.scala 44:14]
    node _GEN_8 = mux(_T_3, _io_out_T_5, _GEN_7) @[Conditional.scala 39:67 alu.scala 41:14]
    node _GEN_9 = mux(_T_2, _io_out_T_4, _GEN_8) @[Conditional.scala 39:67 alu.scala 38:14]
    node _GEN_10 = mux(_T_1, _io_out_T_3, _GEN_9) @[Conditional.scala 39:67 alu.scala 35:14]
    node _GEN_11 = mux(_T, _io_out_T_1, _GEN_10) @[Conditional.scala 40:58 alu.scala 32:14]
    io_out <= bits(_GEN_11, 31, 0)

  module execute :
    input clock : Clock
    input reset : UInt<1>
    input io_A_alu_execute : UInt<32>
    input io_B_alu_execute : UInt<32>
    input io_op_alu_execute : UInt<4>
    output io_out_alu_execute : UInt<32>
    input io_ins_execute : UInt<32>
    input io_imm_execute : UInt<32>
    input io_pc_fetch : UInt<32>
    output io_pc_imm_added : UInt<32>

    inst alumod of alu @[execute.scala 27:24]
    node _T = bits(io_ins_execute, 6, 0) @[execute.scala 37:25]
    node _T_1 = eq(_T, UInt<5>("h13")) @[execute.scala 37:31]
    node _GEN_0 = mux(_T_1, io_imm_execute, io_B_alu_execute) @[execute.scala 37:43 execute.scala 38:17 execute.scala 41:18]
    node _io_pc_imm_added_T = add(io_imm_execute, io_pc_fetch) @[execute.scala 45:41]
    node _io_pc_imm_added_T_1 = tail(_io_pc_imm_added_T, 1) @[execute.scala 45:41]
    io_out_alu_execute <= alumod.io_out @[execute.scala 34:24]
    io_pc_imm_added <= _io_pc_imm_added_T_1 @[execute.scala 45:22]
    alumod.clock <= clock
    alumod.reset <= reset
    alumod.io_A <= io_A_alu_execute @[execute.scala 32:17]
    alumod.io_B <= _GEN_0
    alumod.io_op <= io_op_alu_execute @[execute.scala 33:18]
