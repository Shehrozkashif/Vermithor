circuit topcore :
  module pc :
    input clock : Clock
    input reset : UInt<1>
    input io_imm : UInt<32>
    output io_out : UInt<32>
    input io_jump : UInt<1>
    input io_jump2 : UInt<1>
    input io_jump3 : UInt<1>

    reg pc : UInt<32>, clock with :
      reset => (UInt<1>("h0"), pc) @[pc.scala 18:19]
    node _pc_T = add(pc, UInt<3>("h4")) @[pc.scala 24:11]
    node _pc_T_1 = tail(_pc_T, 1) @[pc.scala 24:11]
    node _GEN_0 = mux(io_jump, io_imm, _pc_T_1) @[pc.scala 20:14 pc.scala 21:4 pc.scala 24:4]
    node _T = eq(pc, UInt<11>("h400")) @[pc.scala 26:9]
    node _GEN_1 = mux(_T, UInt<1>("h0"), _GEN_0) @[pc.scala 26:17 pc.scala 27:4]
    node _GEN_2 = mux(io_jump2, io_imm, _GEN_1) @[pc.scala 29:16 pc.scala 31:4]
    node _GEN_3 = mux(io_jump3, io_imm, _GEN_2) @[pc.scala 34:16 pc.scala 35:4]
    io_out <= pc @[pc.scala 38:8]
    pc <= mux(reset, UInt<32>("h0"), _GEN_3) @[pc.scala 18:19 pc.scala 18:19]

  module Imem :
    input clock : Clock
    input reset : UInt<1>
    input io_data_in : UInt<32>
    input io_enable : UInt<1>
    input io_address : UInt<32>
    output io_out : UInt<32>

    mem memory : @[Imem.scala 13:17]
      data-type => UInt<32>
      depth => 256
      read-latency => 0
      write-latency => 1
      reader => io_out_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = shr(io_address, 2) @[Imem.scala 19:26]
    node _T_1 = bits(_T, 7, 0)
    node _GEN_0 = validif(io_enable, _T_1) @[Imem.scala 18:20]
    node _GEN_1 = validif(io_enable, clock) @[Imem.scala 18:20]
    node _GEN_2 = mux(io_enable, UInt<1>("h1"), UInt<1>("h0")) @[Imem.scala 18:20 Imem.scala 13:17]
    node _GEN_3 = validif(io_enable, UInt<1>("h1")) @[Imem.scala 18:20]
    node _GEN_4 = validif(io_enable, io_data_in) @[Imem.scala 18:20]
    node _io_out_T = shr(io_address, 2) @[Imem.scala 21:35]
    node _io_out_T_1 = bits(_io_out_T, 7, 0) @[Imem.scala 21:22]
    io_out <= memory.io_out_MPORT.data @[Imem.scala 21:8]
    memory.io_out_MPORT.addr <= _io_out_T_1 @[Imem.scala 21:22]
    memory.io_out_MPORT.en <= UInt<1>("h1") @[Imem.scala 21:22]
    memory.io_out_MPORT.clk <= clock @[Imem.scala 21:22]
    memory.MPORT.addr <= _GEN_0
    memory.MPORT.en <= _GEN_2
    memory.MPORT.clk <= _GEN_1
    memory.MPORT.data <= _GEN_4
    memory.MPORT.mask <= _GEN_3

  module fetch :
    input clock : Clock
    input reset : UInt<1>
    input io_imm : UInt<32>
    output io_pcout : UInt<32>
    input io_jump : UInt<1>
    input io_jump2 : UInt<1>
    input io_jump3 : UInt<1>
    input io_data_in : UInt<32>
    input io_enable : UInt<1>
    output io_insout : UInt<32>

    inst pcmod of pc @[fetch.scala 34:19]
    inst inmmod of Imem @[fetch.scala 35:20]
    io_pcout <= pcmod.io_out @[fetch.scala 49:10]
    io_insout <= inmmod.io_out @[fetch.scala 58:12]
    pcmod.clock <= clock
    pcmod.reset <= reset
    pcmod.io_imm <= io_imm @[fetch.scala 43:14]
    pcmod.io_jump <= io_jump @[fetch.scala 44:14]
    pcmod.io_jump2 <= io_jump2 @[fetch.scala 45:15]
    pcmod.io_jump3 <= io_jump3 @[fetch.scala 46:15]
    inmmod.clock <= clock
    inmmod.reset <= reset
    inmmod.io_data_in <= io_data_in @[fetch.scala 53:18]
    inmmod.io_enable <= io_enable @[fetch.scala 54:17]
    inmmod.io_address <= pcmod.io_out @[fetch.scala 55:18]

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
    input io_A : UInt<32>
    input io_B : UInt<32>
    input io_op : UInt<4>
    output io_out : UInt<32>
    input io_rdata1 : UInt<32>
    input io_rdata2 : UInt<32>
    output io_wdata : UInt<32>
    input io_instructioncu : UInt<32>
    input io_func3_7 : UInt<3>
    input io_immg : UInt<32>
    input io_pcout : UInt<32>
    output io_aluout : UInt<32>
    output io_pcjump : UInt<1>
    output io_pcjump2 : UInt<1>
    output io_pcjump3 : UInt<1>
    output io_addr : UInt<8>

    inst alumod of alu @[execute.scala 58:20]
    node _T = bits(io_instructioncu, 6, 0) @[execute.scala 77:22]
    node _T_1 = eq(_T, UInt<2>("h3")) @[execute.scala 77:28]
    node _io_addr_T = bits(alumod.io_out, 9, 2) @[execute.scala 82:27]
    node _T_2 = eq(io_instructioncu, UInt<6>("h23")) @[execute.scala 83:29]
    node _io_addr_T_1 = bits(alumod.io_out, 9, 2) @[execute.scala 88:27]
    node _GEN_0 = mux(_T_2, io_A, io_rdata1) @[execute.scala 84:1 execute.scala 85:14 execute.scala 68:13]
    node _GEN_1 = mux(_T_2, io_B, io_rdata2) @[execute.scala 84:1 execute.scala 86:14 execute.scala 69:13]
    node _GEN_2 = mux(_T_2, UInt<1>("h0"), io_func3_7) @[execute.scala 84:1 execute.scala 87:15 execute.scala 70:13]
    node _GEN_3 = mux(_T_2, _io_addr_T_1, UInt<1>("h0")) @[execute.scala 84:1 execute.scala 88:11 execute.scala 76:9]
    node _GEN_4 = mux(_T_1, io_A, _GEN_0) @[execute.scala 78:1 execute.scala 79:14]
    node _GEN_5 = mux(_T_1, io_B, _GEN_1) @[execute.scala 78:1 execute.scala 80:14]
    node _GEN_6 = mux(_T_1, UInt<1>("h0"), _GEN_2) @[execute.scala 78:1 execute.scala 81:15]
    node _GEN_7 = mux(_T_1, _io_addr_T, _GEN_3) @[execute.scala 78:1 execute.scala 82:11]
    node _T_3 = bits(io_instructioncu, 6, 0) @[execute.scala 98:22]
    node _T_4 = eq(_T_3, UInt<6>("h33")) @[execute.scala 98:28]
    node _T_5 = bits(io_instructioncu, 6, 0) @[execute.scala 102:27]
    node _T_6 = eq(_T_5, UInt<5>("h13")) @[execute.scala 102:33]
    node _GEN_8 = mux(_T_6, io_immg, _GEN_5) @[execute.scala 102:45 execute.scala 103:13]
    node _GEN_9 = mux(_T_4, io_rdata2, _GEN_8) @[execute.scala 98:41 execute.scala 100:13]
    node _T_7 = bits(io_instructioncu, 6, 0) @[execute.scala 108:22]
    node _T_8 = eq(_T_7, UInt<7>("h63")) @[execute.scala 108:29]
    node _T_9 = bits(io_instructioncu, 14, 12) @[execute.scala 118:26]
    node _T_10 = eq(_T_9, UInt<1>("h0")) @[execute.scala 118:35]
    node _T_11 = eq(io_rdata1, io_rdata2) @[execute.scala 119:22]
    node _GEN_10 = mux(_T_11, UInt<1>("h1"), UInt<1>("h0")) @[execute.scala 119:37 execute.scala 120:17 execute.scala 62:12]
    node _T_12 = bits(io_instructioncu, 14, 12) @[execute.scala 122:32]
    node _T_13 = eq(_T_12, UInt<1>("h1")) @[execute.scala 122:41]
    node _T_14 = neq(io_rdata1, io_rdata2) @[execute.scala 123:22]
    node _GEN_11 = mux(_T_14, UInt<1>("h1"), UInt<1>("h0")) @[execute.scala 123:37 execute.scala 124:19 execute.scala 62:12]
    node _T_15 = bits(io_instructioncu, 14, 12) @[execute.scala 126:32]
    node _T_16 = eq(_T_15, UInt<2>("h2")) @[execute.scala 126:41]
    node _T_17 = lt(io_rdata1, io_rdata2) @[execute.scala 127:22]
    node _GEN_12 = mux(_T_17, UInt<1>("h1"), UInt<1>("h0")) @[execute.scala 127:35 execute.scala 128:19 execute.scala 62:12]
    node _T_18 = bits(io_instructioncu, 14, 12) @[execute.scala 130:32]
    node _T_19 = eq(_T_18, UInt<2>("h3")) @[execute.scala 130:41]
    node _T_20 = geq(io_rdata1, io_rdata2) @[execute.scala 131:22]
    node _GEN_13 = mux(_T_20, UInt<1>("h1"), UInt<1>("h0")) @[execute.scala 131:36 execute.scala 132:19 execute.scala 62:12]
    node _T_21 = bits(io_instructioncu, 14, 12) @[execute.scala 134:32]
    node _T_22 = eq(_T_21, UInt<3>("h4")) @[execute.scala 134:41]
    node _T_23 = lt(io_rdata1, io_rdata2) @[execute.scala 135:29]
    node _GEN_14 = mux(_T_23, UInt<1>("h1"), UInt<1>("h0")) @[execute.scala 135:51 execute.scala 136:19 execute.scala 62:12]
    node _T_24 = bits(io_instructioncu, 14, 12) @[execute.scala 138:32]
    node _T_25 = eq(_T_24, UInt<3>("h5")) @[execute.scala 138:41]
    node _T_26 = geq(io_rdata1, io_rdata2) @[execute.scala 139:29]
    node _GEN_15 = mux(_T_26, UInt<1>("h1"), UInt<1>("h0")) @[execute.scala 139:52 execute.scala 140:19 execute.scala 62:12]
    node _GEN_16 = mux(_T_25, _GEN_15, UInt<1>("h0")) @[execute.scala 138:50 execute.scala 62:12]
    node _GEN_17 = mux(_T_22, _GEN_14, _GEN_16) @[execute.scala 134:50]
    node _GEN_18 = mux(_T_19, _GEN_13, _GEN_17) @[execute.scala 130:50]
    node _GEN_19 = mux(_T_16, _GEN_12, _GEN_18) @[execute.scala 126:50]
    node _GEN_20 = mux(_T_13, _GEN_11, _GEN_19) @[execute.scala 122:50]
    node _GEN_21 = mux(_T_10, _GEN_10, _GEN_20) @[execute.scala 118:44]
    node _GEN_22 = mux(_T_8, UInt<1>("h0"), _GEN_6) @[execute.scala 108:39 execute.scala 109:15]
    node _GEN_23 = mux(_T_8, io_pcout, _GEN_4) @[execute.scala 108:39 execute.scala 110:15]
    node _GEN_24 = mux(_T_8, io_immg, _GEN_9) @[execute.scala 108:39 execute.scala 111:15]
    node _GEN_25 = mux(_T_8, alumod.io_out, alumod.io_out) @[execute.scala 108:39 execute.scala 117:15 execute.scala 74:11]
    node _GEN_26 = mux(_T_8, _GEN_21, UInt<1>("h0")) @[execute.scala 108:39 execute.scala 62:12]
    node _T_27 = bits(io_instructioncu, 6, 0) @[execute.scala 147:22]
    node _T_28 = eq(_T_27, UInt<6>("h37")) @[execute.scala 147:28]
    node _GEN_27 = mux(_T_28, io_immg, alumod.io_out) @[execute.scala 147:41 execute.scala 148:10 execute.scala 73:10]
    node _T_29 = bits(io_instructioncu, 6, 0) @[execute.scala 150:22]
    node _T_30 = eq(_T_29, UInt<5>("h17")) @[execute.scala 150:28]
    node _GEN_28 = mux(_T_30, UInt<1>("h0"), _GEN_22) @[execute.scala 150:41 execute.scala 151:13]
    node _GEN_29 = mux(_T_30, io_pcout, _GEN_23) @[execute.scala 150:41 execute.scala 152:15]
    node _GEN_30 = mux(_T_30, io_immg, _GEN_24) @[execute.scala 150:41 execute.scala 153:15]
    node _GEN_31 = mux(_T_30, alumod.io_out, _GEN_27) @[execute.scala 150:41 execute.scala 155:10]
    node _T_31 = bits(io_instructioncu, 6, 0) @[execute.scala 160:22]
    node _T_32 = eq(_T_31, UInt<7>("h6f")) @[execute.scala 160:28]
    node _io_wdata_T = add(io_pcout, UInt<3>("h4")) @[execute.scala 168:26]
    node _io_wdata_T_1 = tail(_io_wdata_T, 1) @[execute.scala 168:26]
    node _GEN_32 = mux(_T_32, UInt<1>("h1"), UInt<1>("h0")) @[execute.scala 160:40 execute.scala 161:14 execute.scala 61:12]
    node _GEN_33 = mux(_T_32, UInt<1>("h0"), _GEN_28) @[execute.scala 160:40 execute.scala 163:15]
    node _GEN_34 = mux(_T_32, io_pcout, _GEN_29) @[execute.scala 160:40 execute.scala 164:15]
    node _GEN_35 = mux(_T_32, io_immg, _GEN_30) @[execute.scala 160:40 execute.scala 165:15]
    node _GEN_36 = mux(_T_32, _io_wdata_T_1, _GEN_31) @[execute.scala 160:40 execute.scala 168:12]
    node _GEN_37 = mux(_T_32, alumod.io_out, _GEN_25) @[execute.scala 160:40 execute.scala 169:13]
    node _T_33 = bits(io_instructioncu, 6, 0) @[execute.scala 172:22]
    node _T_34 = eq(_T_33, UInt<7>("h67")) @[execute.scala 172:28]
    node _io_wdata_T_2 = add(io_pcout, UInt<3>("h4")) @[execute.scala 180:26]
    node _io_wdata_T_3 = tail(_io_wdata_T_2, 1) @[execute.scala 180:26]
    node _GEN_38 = mux(_T_34, UInt<1>("h1"), UInt<1>("h0")) @[execute.scala 172:40 execute.scala 173:14 execute.scala 60:12]
    node _GEN_39 = mux(_T_34, UInt<1>("h0"), _GEN_33) @[execute.scala 172:40 execute.scala 175:15]
    node _GEN_40 = mux(_T_34, io_rdata1, _GEN_34) @[execute.scala 172:40 execute.scala 176:13]
    node _GEN_41 = mux(_T_34, io_immg, _GEN_35) @[execute.scala 172:40 execute.scala 177:15]
    node _GEN_42 = mux(_T_34, _io_wdata_T_3, _GEN_36) @[execute.scala 172:40 execute.scala 180:12]
    node _GEN_43 = mux(_T_34, alumod.io_out, _GEN_37) @[execute.scala 172:40 execute.scala 181:13]
    io_out <= alumod.io_out @[execute.scala 71:10]
    io_wdata <= _GEN_42
    io_aluout <= _GEN_43
    io_pcjump <= _GEN_26
    io_pcjump2 <= _GEN_32
    io_pcjump3 <= _GEN_38
    io_addr <= _GEN_7
    alumod.clock <= clock
    alumod.reset <= reset
    alumod.io_A <= _GEN_40
    alumod.io_B <= _GEN_41
    alumod.io_op <= _GEN_39

  module wb :
    input clock : Clock
    input reset : UInt<1>
    output io_dataout : UInt<32>
    input io_datamemin : UInt<32>
    input io_ins : UInt<32>

    node _io_dataout_T = bits(io_ins, 6, 0) @[wb.scala 19:26]
    node _io_dataout_T_1 = eq(_io_dataout_T, UInt<2>("h3")) @[wb.scala 19:31]
    node _io_dataout_T_2 = mux(_io_dataout_T_1, io_datamemin, UInt<1>("h0")) @[wb.scala 19:19]
    io_dataout <= _io_dataout_T_2 @[wb.scala 19:13]

  module datamemory :
    input clock : Clock
    input reset : UInt<1>
    output io_out_0 : UInt<8>
    output io_out_1 : UInt<8>
    output io_out_2 : UInt<8>
    output io_out_3 : UInt<8>
    input io_addr : UInt<8>
    input io_rd_enable : UInt<1>
    input io_wr_enable : UInt<1>
    input io_mask_0 : UInt<1>
    input io_mask_1 : UInt<1>
    input io_mask_2 : UInt<1>
    input io_mask_3 : UInt<1>
    input io_dataIn_0 : UInt<8>
    input io_dataIn_1 : UInt<8>
    input io_dataIn_2 : UInt<8>
    input io_dataIn_3 : UInt<8>

    mem memory_0 : @[datamemory.scala 22:19]
      data-type => UInt<8>
      depth => 256
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    mem memory_1 : @[datamemory.scala 22:19]
      data-type => UInt<8>
      depth => 256
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    mem memory_2 : @[datamemory.scala 22:19]
      data-type => UInt<8>
      depth => 256
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    mem memory_3 : @[datamemory.scala 22:19]
      data-type => UInt<8>
      depth => 256
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    node _GEN_0 = validif(io_mask_0, io_dataIn_0)
    node _GEN_1 = mux(io_mask_0, UInt<1>("h1"), UInt<1>("h0"))
    node _GEN_2 = validif(io_mask_1, io_dataIn_1)
    node _GEN_3 = mux(io_mask_1, UInt<1>("h1"), UInt<1>("h0"))
    node _GEN_4 = validif(io_mask_2, io_dataIn_2)
    node _GEN_5 = mux(io_mask_2, UInt<1>("h1"), UInt<1>("h0"))
    node _GEN_6 = validif(io_mask_3, io_dataIn_3)
    node _GEN_7 = mux(io_mask_3, UInt<1>("h1"), UInt<1>("h0"))
    node _GEN_8 = validif(io_wr_enable, io_addr) @[datamemory.scala 25:22]
    node _GEN_9 = validif(io_wr_enable, clock) @[datamemory.scala 25:22]
    node _GEN_10 = mux(io_wr_enable, UInt<1>("h1"), UInt<1>("h0")) @[datamemory.scala 25:22 datamemory.scala 22:19]
    node _GEN_11 = validif(io_wr_enable, _GEN_1) @[datamemory.scala 25:22]
    node _GEN_12 = validif(io_wr_enable, _GEN_3) @[datamemory.scala 25:22]
    node _GEN_13 = validif(io_wr_enable, _GEN_5) @[datamemory.scala 25:22]
    node _GEN_14 = validif(io_wr_enable, _GEN_7) @[datamemory.scala 25:22]
    node _GEN_15 = validif(io_wr_enable, _GEN_0) @[datamemory.scala 25:22]
    node _GEN_16 = validif(io_wr_enable, _GEN_2) @[datamemory.scala 25:22]
    node _GEN_17 = validif(io_wr_enable, _GEN_4) @[datamemory.scala 25:22]
    node _GEN_18 = validif(io_wr_enable, _GEN_6) @[datamemory.scala 25:22]
    node _GEN_19 = validif(io_rd_enable, io_addr) @[datamemory.scala 28:22 datamemory.scala 29:26]
    node _GEN_20 = validif(io_rd_enable, clock) @[datamemory.scala 28:22 datamemory.scala 29:26]
    node _GEN_21 = mux(io_rd_enable, UInt<1>("h1"), UInt<1>("h0")) @[datamemory.scala 28:22 datamemory.scala 29:26 datamemory.scala 22:19]
    node _GEN_22 = mux(io_rd_enable, memory_0.MPORT_1.data, UInt<1>("h0")) @[datamemory.scala 28:22 datamemory.scala 29:12 datamemory.scala 16:13]
    node _GEN_23 = mux(io_rd_enable, memory_1.MPORT_1.data, UInt<1>("h0")) @[datamemory.scala 28:22 datamemory.scala 29:12 datamemory.scala 17:13]
    node _GEN_24 = mux(io_rd_enable, memory_2.MPORT_1.data, UInt<1>("h0")) @[datamemory.scala 28:22 datamemory.scala 29:12 datamemory.scala 18:13]
    node _GEN_25 = mux(io_rd_enable, memory_3.MPORT_1.data, UInt<1>("h0")) @[datamemory.scala 28:22 datamemory.scala 29:12 datamemory.scala 19:13]
    io_out_0 <= _GEN_22
    io_out_1 <= _GEN_23
    io_out_2 <= _GEN_24
    io_out_3 <= _GEN_25
    memory_0.MPORT_1.addr <= _GEN_19
    memory_1.MPORT_1.addr <= _GEN_19
    memory_2.MPORT_1.addr <= _GEN_19
    memory_3.MPORT_1.addr <= _GEN_19
    memory_0.MPORT_1.en <= _GEN_21
    memory_1.MPORT_1.en <= _GEN_21
    memory_2.MPORT_1.en <= _GEN_21
    memory_3.MPORT_1.en <= _GEN_21
    memory_0.MPORT_1.clk <= _GEN_20
    memory_1.MPORT_1.clk <= _GEN_20
    memory_2.MPORT_1.clk <= _GEN_20
    memory_3.MPORT_1.clk <= _GEN_20
    memory_0.MPORT.addr <= _GEN_8
    memory_1.MPORT.addr <= _GEN_8
    memory_2.MPORT.addr <= _GEN_8
    memory_3.MPORT.addr <= _GEN_8
    memory_0.MPORT.en <= _GEN_10
    memory_1.MPORT.en <= _GEN_10
    memory_2.MPORT.en <= _GEN_10
    memory_3.MPORT.en <= _GEN_10
    memory_0.MPORT.clk <= _GEN_9
    memory_1.MPORT.clk <= _GEN_9
    memory_2.MPORT.clk <= _GEN_9
    memory_3.MPORT.clk <= _GEN_9
    memory_0.MPORT.data <= _GEN_15
    memory_1.MPORT.data <= _GEN_16
    memory_2.MPORT.data <= _GEN_17
    memory_3.MPORT.data <= _GEN_18
    memory_0.MPORT.mask <= _GEN_11
    memory_1.MPORT.mask <= _GEN_12
    memory_2.MPORT.mask <= _GEN_13
    memory_3.MPORT.mask <= _GEN_14

  module mem :
    input clock : Clock
    input reset : UInt<1>
    input io_rd_enable : UInt<1>
    input io_wr_enable : UInt<1>
    input io_dataIn_0 : UInt<8>
    input io_dataIn_1 : UInt<8>
    input io_dataIn_2 : UInt<8>
    input io_dataIn_3 : UInt<8>
    output io_dataout_0 : UInt<8>
    output io_dataout_1 : UInt<8>
    output io_dataout_2 : UInt<8>
    output io_dataout_3 : UInt<8>
    input io_instruction : UInt<32>
    output io_A : UInt<32>
    output io_B : UInt<32>
    output io_op : UInt<4>
    input io_aluout : UInt<32>
    input io_imm : UInt<32>
    input io_rdata1 : UInt<32>
    input io_rdata2 : UInt<32>
    output io_wdata : UInt<32>

    inst dmmod of datamemory @[mem.scala 48:18]
    node _T = bits(io_instruction, 6, 0) @[mem.scala 95:20]
    node _T_1 = eq(_T, UInt<6>("h23")) @[mem.scala 95:26]
    node _dmmod_io_addr_T = bits(io_aluout, 9, 2) @[mem.scala 101:29]
    node masksel = bits(io_aluout, 1, 0) @[mem.scala 103:26]
    node _T_2 = bits(io_instruction, 14, 12) @[mem.scala 105:22]
    node _T_3 = eq(_T_2, UInt<1>("h0")) @[mem.scala 105:30]
    node _T_4 = eq(masksel, UInt<1>("h0")) @[mem.scala 107:18]
    node _dmmod_io_dataIn_0_T = bits(io_rdata2, 7, 0) @[mem.scala 114:40]
    node _T_5 = eq(masksel, UInt<1>("h1")) @[mem.scala 120:25]
    node _dmmod_io_dataIn_1_T = bits(io_rdata2, 7, 0) @[mem.scala 128:40]
    node _T_6 = eq(masksel, UInt<2>("h2")) @[mem.scala 133:25]
    node _dmmod_io_dataIn_2_T = bits(io_rdata2, 7, 0) @[mem.scala 142:40]
    node _T_7 = eq(masksel, UInt<2>("h3")) @[mem.scala 146:25]
    node _dmmod_io_dataIn_3_T = bits(io_rdata2, 7, 0) @[mem.scala 156:40]
    node _GEN_0 = mux(_T_7, UInt<1>("h0"), UInt<1>("h0")) @[mem.scala 147:7 mem.scala 148:26 mem.scala 83:18]
    node _GEN_1 = mux(_T_7, UInt<1>("h1"), UInt<1>("h0")) @[mem.scala 147:7 mem.scala 151:26 mem.scala 86:18]
    node _GEN_2 = mux(_T_7, _dmmod_io_dataIn_3_T, io_dataIn_3) @[mem.scala 147:7 mem.scala 156:28 mem.scala 81:17]
    node _GEN_3 = mux(_T_6, UInt<1>("h0"), _GEN_0) @[mem.scala 134:7 mem.scala 135:26]
    node _GEN_4 = mux(_T_6, UInt<1>("h1"), _GEN_0) @[mem.scala 134:7 mem.scala 137:26]
    node _GEN_5 = mux(_T_6, UInt<1>("h0"), _GEN_1) @[mem.scala 134:7 mem.scala 138:26]
    node _GEN_6 = mux(_T_6, _dmmod_io_dataIn_2_T, io_dataIn_2) @[mem.scala 134:7 mem.scala 142:28 mem.scala 81:17]
    node _GEN_7 = mux(_T_6, io_dataIn_3, _GEN_2) @[mem.scala 134:7 mem.scala 81:17]
    node _GEN_8 = mux(_T_5, UInt<1>("h0"), _GEN_3) @[mem.scala 121:7 mem.scala 122:26]
    node _GEN_9 = mux(_T_5, UInt<1>("h1"), _GEN_3) @[mem.scala 121:7 mem.scala 123:26]
    node _GEN_10 = mux(_T_5, UInt<1>("h0"), _GEN_4) @[mem.scala 121:7 mem.scala 124:26]
    node _GEN_11 = mux(_T_5, UInt<1>("h0"), _GEN_5) @[mem.scala 121:7 mem.scala 125:26]
    node _GEN_12 = mux(_T_5, _dmmod_io_dataIn_1_T, io_dataIn_1) @[mem.scala 121:7 mem.scala 128:28 mem.scala 81:17]
    node _GEN_13 = mux(_T_5, io_dataIn_2, _GEN_6) @[mem.scala 121:7 mem.scala 81:17]
    node _GEN_14 = mux(_T_5, io_dataIn_3, _GEN_7) @[mem.scala 121:7 mem.scala 81:17]
    node _GEN_15 = mux(_T_4, UInt<1>("h1"), _GEN_8) @[mem.scala 108:7 mem.scala 109:26]
    node _GEN_16 = mux(_T_4, UInt<1>("h0"), _GEN_9) @[mem.scala 108:7 mem.scala 110:26]
    node _GEN_17 = mux(_T_4, UInt<1>("h0"), _GEN_10) @[mem.scala 108:7 mem.scala 111:26]
    node _GEN_18 = mux(_T_4, UInt<1>("h0"), _GEN_11) @[mem.scala 108:7 mem.scala 112:26]
    node _GEN_19 = mux(_T_4, _dmmod_io_dataIn_0_T, io_dataIn_0) @[mem.scala 108:7 mem.scala 114:28 mem.scala 81:17]
    node _GEN_20 = mux(_T_4, io_dataIn_1, _GEN_12) @[mem.scala 108:7 mem.scala 81:17]
    node _GEN_21 = mux(_T_4, io_dataIn_2, _GEN_13) @[mem.scala 108:7 mem.scala 81:17]
    node _GEN_22 = mux(_T_4, io_dataIn_3, _GEN_14) @[mem.scala 108:7 mem.scala 81:17]
    node _T_8 = bits(io_instruction, 14, 12) @[mem.scala 161:28]
    node _T_9 = eq(_T_8, UInt<1>("h1")) @[mem.scala 161:36]
    node _T_10 = eq(masksel, UInt<1>("h0")) @[mem.scala 163:16]
    node _dmmod_io_dataIn_0_T_1 = bits(io_rdata2, 7, 0) @[mem.scala 170:40]
    node _dmmod_io_dataIn_1_T_1 = bits(io_rdata2, 15, 8) @[mem.scala 171:40]
    node _GEN_23 = mux(_T_10, UInt<1>("h1"), UInt<1>("h0")) @[mem.scala 164:7 mem.scala 165:26 mem.scala 83:18]
    node _GEN_24 = mux(_T_10, UInt<1>("h0"), UInt<1>("h0")) @[mem.scala 164:7 mem.scala 167:26 mem.scala 85:18]
    node _GEN_25 = mux(_T_10, _dmmod_io_dataIn_0_T_1, io_dataIn_0) @[mem.scala 164:7 mem.scala 170:28 mem.scala 81:17]
    node _GEN_26 = mux(_T_10, _dmmod_io_dataIn_1_T_1, io_dataIn_1) @[mem.scala 164:7 mem.scala 171:28 mem.scala 81:17]
    node _T_11 = eq(masksel, UInt<1>("h1")) @[mem.scala 178:16]
    node _dmmod_io_dataIn_1_T_2 = bits(io_rdata2, 7, 0) @[mem.scala 186:40]
    node _dmmod_io_dataIn_2_T_1 = bits(io_rdata2, 15, 8) @[mem.scala 187:40]
    node _GEN_27 = mux(_T_11, UInt<1>("h0"), _GEN_23) @[mem.scala 179:7 mem.scala 180:26]
    node _GEN_28 = mux(_T_11, UInt<1>("h1"), _GEN_23) @[mem.scala 179:7 mem.scala 181:26]
    node _GEN_29 = mux(_T_11, UInt<1>("h1"), _GEN_24) @[mem.scala 179:7 mem.scala 182:26]
    node _GEN_30 = mux(_T_11, UInt<1>("h0"), _GEN_24) @[mem.scala 179:7 mem.scala 183:26]
    node _GEN_31 = mux(_T_11, _dmmod_io_dataIn_1_T_2, _GEN_26) @[mem.scala 179:7 mem.scala 186:28]
    node _GEN_32 = mux(_T_11, _dmmod_io_dataIn_2_T_1, io_dataIn_2) @[mem.scala 179:7 mem.scala 187:28 mem.scala 81:17]
    node _T_12 = eq(masksel, UInt<2>("h2")) @[mem.scala 192:15]
    node _dmmod_io_dataIn_2_T_2 = bits(io_rdata2, 7, 0) @[mem.scala 201:40]
    node _dmmod_io_dataIn_3_T_1 = bits(io_rdata2, 15, 8) @[mem.scala 202:40]
    node _GEN_33 = mux(_T_12, UInt<1>("h0"), _GEN_27) @[mem.scala 193:7 mem.scala 194:26]
    node _GEN_34 = mux(_T_12, UInt<1>("h0"), _GEN_28) @[mem.scala 193:7 mem.scala 195:26]
    node _GEN_35 = mux(_T_12, UInt<1>("h1"), _GEN_29) @[mem.scala 193:7 mem.scala 196:26]
    node _GEN_36 = mux(_T_12, UInt<1>("h1"), _GEN_30) @[mem.scala 193:7 mem.scala 197:26]
    node _GEN_37 = mux(_T_12, _dmmod_io_dataIn_2_T_2, _GEN_32) @[mem.scala 193:7 mem.scala 201:28]
    node _GEN_38 = mux(_T_12, _dmmod_io_dataIn_3_T_1, io_dataIn_3) @[mem.scala 193:7 mem.scala 202:28 mem.scala 81:17]
    node _T_13 = eq(masksel, UInt<2>("h3")) @[mem.scala 206:21]
    node _dmmod_io_dataIn_0_T_2 = bits(io_rdata2, 15, 8) @[mem.scala 213:40]
    node _dmmod_io_dataIn_3_T_2 = bits(io_rdata2, 7, 0) @[mem.scala 216:40]
    node _GEN_39 = mux(_T_13, UInt<1>("h1"), _GEN_33) @[mem.scala 207:7 mem.scala 208:26]
    node _GEN_40 = mux(_T_13, UInt<1>("h0"), _GEN_34) @[mem.scala 207:7 mem.scala 209:26]
    node _GEN_41 = mux(_T_13, UInt<1>("h0"), _GEN_35) @[mem.scala 207:7 mem.scala 210:26]
    node _GEN_42 = mux(_T_13, UInt<1>("h1"), _GEN_36) @[mem.scala 207:7 mem.scala 211:26]
    node _GEN_43 = mux(_T_13, _dmmod_io_dataIn_0_T_2, _GEN_25) @[mem.scala 207:7 mem.scala 213:28]
    node _GEN_44 = mux(_T_13, _dmmod_io_dataIn_3_T_2, _GEN_38) @[mem.scala 207:7 mem.scala 216:28]
    node _T_14 = bits(io_instruction, 14, 12) @[mem.scala 220:28]
    node _T_15 = eq(_T_14, UInt<2>("h2")) @[mem.scala 220:36]
    node _dmmod_io_dataIn_0_T_3 = bits(io_rdata2, 7, 0) @[mem.scala 229:40]
    node _dmmod_io_dataIn_1_T_3 = bits(io_rdata2, 15, 8) @[mem.scala 230:40]
    node _dmmod_io_dataIn_2_T_3 = bits(io_rdata2, 23, 16) @[mem.scala 231:40]
    node _dmmod_io_dataIn_3_T_3 = bits(io_rdata2, 31, 24) @[mem.scala 232:40]
    node _GEN_45 = mux(_T_15, UInt<1>("h1"), UInt<1>("h0")) @[mem.scala 220:44 mem.scala 224:26 mem.scala 83:18]
    node _GEN_46 = mux(_T_15, _dmmod_io_dataIn_0_T_3, io_dataIn_0) @[mem.scala 220:44 mem.scala 229:28 mem.scala 81:17]
    node _GEN_47 = mux(_T_15, _dmmod_io_dataIn_1_T_3, io_dataIn_1) @[mem.scala 220:44 mem.scala 230:28 mem.scala 81:17]
    node _GEN_48 = mux(_T_15, _dmmod_io_dataIn_2_T_3, io_dataIn_2) @[mem.scala 220:44 mem.scala 231:28 mem.scala 81:17]
    node _GEN_49 = mux(_T_15, _dmmod_io_dataIn_3_T_3, io_dataIn_3) @[mem.scala 220:44 mem.scala 232:28 mem.scala 81:17]
    node _GEN_50 = mux(_T_9, _GEN_39, _GEN_45) @[mem.scala 161:44]
    node _GEN_51 = mux(_T_9, _GEN_40, _GEN_45) @[mem.scala 161:44]
    node _GEN_52 = mux(_T_9, _GEN_41, _GEN_45) @[mem.scala 161:44]
    node _GEN_53 = mux(_T_9, _GEN_42, _GEN_45) @[mem.scala 161:44]
    node _GEN_54 = mux(_T_9, _GEN_43, _GEN_46) @[mem.scala 161:44]
    node _GEN_55 = mux(_T_9, _GEN_31, _GEN_47) @[mem.scala 161:44]
    node _GEN_56 = mux(_T_9, _GEN_37, _GEN_48) @[mem.scala 161:44]
    node _GEN_57 = mux(_T_9, _GEN_44, _GEN_49) @[mem.scala 161:44]
    node _GEN_58 = mux(_T_3, _GEN_15, _GEN_50) @[mem.scala 105:38]
    node _GEN_59 = mux(_T_3, _GEN_16, _GEN_51) @[mem.scala 105:38]
    node _GEN_60 = mux(_T_3, _GEN_17, _GEN_52) @[mem.scala 105:38]
    node _GEN_61 = mux(_T_3, _GEN_18, _GEN_53) @[mem.scala 105:38]
    node _GEN_62 = mux(_T_3, _GEN_19, _GEN_54) @[mem.scala 105:38]
    node _GEN_63 = mux(_T_3, _GEN_20, _GEN_55) @[mem.scala 105:38]
    node _GEN_64 = mux(_T_3, _GEN_21, _GEN_56) @[mem.scala 105:38]
    node _GEN_65 = mux(_T_3, _GEN_22, _GEN_57) @[mem.scala 105:38]
    node _GEN_66 = mux(_T_1, UInt<1>("h0"), UInt<1>("h0")) @[mem.scala 95:39 mem.scala 96:8 mem.scala 45:8]
    node _GEN_67 = mux(_T_1, io_rdata1, UInt<1>("h0")) @[mem.scala 95:39 mem.scala 97:8 mem.scala 43:8]
    node _GEN_68 = mux(_T_1, io_imm, UInt<1>("h0")) @[mem.scala 95:39 mem.scala 98:8 mem.scala 44:8]
    node _GEN_69 = mux(_T_1, UInt<1>("h1"), UInt<1>("h0")) @[mem.scala 95:39 mem.scala 99:22 mem.scala 93:20]
    node _GEN_70 = mux(_T_1, _dmmod_io_addr_T, UInt<1>("h0")) @[mem.scala 95:39 mem.scala 101:17 mem.scala 51:14]
    node _GEN_71 = mux(_T_1, _GEN_58, UInt<1>("h0")) @[mem.scala 95:39 mem.scala 83:18]
    node _GEN_72 = mux(_T_1, _GEN_59, UInt<1>("h0")) @[mem.scala 95:39 mem.scala 84:18]
    node _GEN_73 = mux(_T_1, _GEN_60, UInt<1>("h0")) @[mem.scala 95:39 mem.scala 85:18]
    node _GEN_74 = mux(_T_1, _GEN_61, UInt<1>("h0")) @[mem.scala 95:39 mem.scala 86:18]
    node _GEN_75 = mux(_T_1, _GEN_62, io_dataIn_0) @[mem.scala 95:39 mem.scala 81:17]
    node _GEN_76 = mux(_T_1, _GEN_63, io_dataIn_1) @[mem.scala 95:39 mem.scala 81:17]
    node _GEN_77 = mux(_T_1, _GEN_64, io_dataIn_2) @[mem.scala 95:39 mem.scala 81:17]
    node _GEN_78 = mux(_T_1, _GEN_65, io_dataIn_3) @[mem.scala 95:39 mem.scala 81:17]
    node _T_16 = bits(io_instruction, 6, 0) @[mem.scala 242:20]
    node _T_17 = eq(_T_16, UInt<2>("h3")) @[mem.scala 242:26]
    node _dmmod_io_addr_T_1 = bits(io_aluout, 9, 2) @[mem.scala 248:29]
    node masksel_1 = bits(io_aluout, 1, 0) @[mem.scala 250:30]
    node _T_18 = bits(io_instruction, 14, 12) @[mem.scala 252:24]
    node _T_19 = eq(_T_18, UInt<1>("h0")) @[mem.scala 252:32]
    node _T_20 = eq(masksel_1, UInt<1>("h0")) @[mem.scala 255:17]
    node _io_wdata_T = bits(dmmod.io_out_0, 7, 7) @[mem.scala 256:48]
    node _io_wdata_T_1 = bits(_io_wdata_T, 0, 0) @[Bitwise.scala 72:15]
    node io_wdata_hi = mux(_io_wdata_T_1, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_wdata_T_2 = cat(io_wdata_hi, dmmod.io_out_0) @[Cat.scala 30:58]
    node _T_21 = eq(masksel_1, UInt<1>("h1")) @[mem.scala 257:24]
    node _io_wdata_T_3 = bits(dmmod.io_out_1, 7, 7) @[mem.scala 258:48]
    node _io_wdata_T_4 = bits(_io_wdata_T_3, 0, 0) @[Bitwise.scala 72:15]
    node io_wdata_hi_1 = mux(_io_wdata_T_4, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_wdata_T_5 = cat(io_wdata_hi_1, dmmod.io_out_1) @[Cat.scala 30:58]
    node _T_22 = eq(masksel_1, UInt<2>("h2")) @[mem.scala 259:24]
    node _io_wdata_T_6 = bits(dmmod.io_out_2, 7, 7) @[mem.scala 260:48]
    node _io_wdata_T_7 = bits(_io_wdata_T_6, 0, 0) @[Bitwise.scala 72:15]
    node io_wdata_hi_2 = mux(_io_wdata_T_7, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_wdata_T_8 = cat(io_wdata_hi_2, dmmod.io_out_2) @[Cat.scala 30:58]
    node _T_23 = eq(masksel_1, UInt<2>("h3")) @[mem.scala 261:24]
    node _io_wdata_T_9 = bits(dmmod.io_out_3, 7, 7) @[mem.scala 262:48]
    node _io_wdata_T_10 = bits(_io_wdata_T_9, 0, 0) @[Bitwise.scala 72:15]
    node io_wdata_hi_3 = mux(_io_wdata_T_10, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_wdata_T_11 = cat(io_wdata_hi_3, dmmod.io_out_3) @[Cat.scala 30:58]
    node _GEN_79 = mux(_T_23, _io_wdata_T_11, io_aluout) @[mem.scala 261:32 mem.scala 262:16 mem.scala 54:10]
    node _GEN_80 = mux(_T_22, _io_wdata_T_8, _GEN_79) @[mem.scala 259:32 mem.scala 260:16]
    node _GEN_81 = mux(_T_21, _io_wdata_T_5, _GEN_80) @[mem.scala 257:32 mem.scala 258:16]
    node _GEN_82 = mux(_T_20, _io_wdata_T_2, _GEN_81) @[mem.scala 255:25 mem.scala 256:16]
    node _T_24 = bits(io_instruction, 14, 12) @[mem.scala 265:30]
    node _T_25 = eq(_T_24, UInt<1>("h1")) @[mem.scala 265:38]
    node _T_26 = eq(masksel_1, UInt<1>("h0")) @[mem.scala 267:20]
    node _io_wdata_T_12 = bits(dmmod.io_out_1, 7, 7) @[mem.scala 268:48]
    node _io_wdata_T_13 = bits(_io_wdata_T_12, 0, 0) @[Bitwise.scala 72:15]
    node io_wdata_hi_hi = mux(_io_wdata_T_13, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node io_wdata_hi_4 = cat(io_wdata_hi_hi, dmmod.io_out_1) @[Cat.scala 30:58]
    node _io_wdata_T_14 = cat(io_wdata_hi_4, dmmod.io_out_0) @[Cat.scala 30:58]
    node _T_27 = eq(masksel_1, UInt<1>("h1")) @[mem.scala 269:24]
    node _io_wdata_T_15 = bits(dmmod.io_out_2, 7, 7) @[mem.scala 270:48]
    node _io_wdata_T_16 = bits(_io_wdata_T_15, 0, 0) @[Bitwise.scala 72:15]
    node io_wdata_hi_hi_1 = mux(_io_wdata_T_16, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node io_wdata_hi_5 = cat(io_wdata_hi_hi_1, dmmod.io_out_2) @[Cat.scala 30:58]
    node _io_wdata_T_17 = cat(io_wdata_hi_5, dmmod.io_out_1) @[Cat.scala 30:58]
    node _T_28 = eq(masksel_1, UInt<2>("h2")) @[mem.scala 271:24]
    node _io_wdata_T_18 = bits(dmmod.io_out_3, 7, 7) @[mem.scala 272:48]
    node _io_wdata_T_19 = bits(_io_wdata_T_18, 0, 0) @[Bitwise.scala 72:15]
    node io_wdata_hi_hi_2 = mux(_io_wdata_T_19, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node io_wdata_hi_6 = cat(io_wdata_hi_hi_2, dmmod.io_out_3) @[Cat.scala 30:58]
    node _io_wdata_T_20 = cat(io_wdata_hi_6, dmmod.io_out_2) @[Cat.scala 30:58]
    node _T_29 = eq(masksel_1, UInt<2>("h3")) @[mem.scala 273:24]
    node _io_wdata_T_21 = bits(dmmod.io_out_0, 7, 7) @[mem.scala 274:48]
    node _io_wdata_T_22 = bits(_io_wdata_T_21, 0, 0) @[Bitwise.scala 72:15]
    node io_wdata_hi_hi_3 = mux(_io_wdata_T_22, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node io_wdata_hi_7 = cat(io_wdata_hi_hi_3, dmmod.io_out_0) @[Cat.scala 30:58]
    node _io_wdata_T_23 = cat(io_wdata_hi_7, dmmod.io_out_3) @[Cat.scala 30:58]
    node _GEN_83 = mux(_T_29, _io_wdata_T_23, io_aluout) @[mem.scala 273:32 mem.scala 274:16 mem.scala 54:10]
    node _GEN_84 = mux(_T_28, _io_wdata_T_20, _GEN_83) @[mem.scala 271:32 mem.scala 272:16]
    node _GEN_85 = mux(_T_27, _io_wdata_T_17, _GEN_84) @[mem.scala 269:32 mem.scala 270:16]
    node _GEN_86 = mux(_T_26, _io_wdata_T_14, _GEN_85) @[mem.scala 267:28 mem.scala 268:16]
    node _T_30 = bits(io_instruction, 14, 12) @[mem.scala 279:30]
    node _T_31 = eq(_T_30, UInt<2>("h2")) @[mem.scala 279:38]
    node io_wdata_lo = cat(dmmod.io_out_1, dmmod.io_out_0) @[Cat.scala 30:58]
    node io_wdata_hi_8 = cat(dmmod.io_out_3, dmmod.io_out_2) @[Cat.scala 30:58]
    node _io_wdata_T_24 = cat(io_wdata_hi_8, io_wdata_lo) @[Cat.scala 30:58]
    node _T_32 = bits(io_instruction, 14, 12) @[mem.scala 283:30]
    node _T_33 = eq(_T_32, UInt<3>("h4")) @[mem.scala 283:38]
    node _T_34 = eq(masksel_1, UInt<1>("h0")) @[mem.scala 285:19]
    node _io_wdata_T_25 = bits(dmmod.io_out_0, 7, 7) @[mem.scala 286:48]
    node _io_wdata_T_26 = bits(_io_wdata_T_25, 0, 0) @[Bitwise.scala 72:15]
    node io_wdata_hi_9 = mux(_io_wdata_T_26, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_wdata_T_27 = cat(io_wdata_hi_9, dmmod.io_out_0) @[Cat.scala 30:58]
    node _T_35 = eq(masksel_1, UInt<1>("h1")) @[mem.scala 287:24]
    node _io_wdata_T_28 = bits(dmmod.io_out_1, 7, 7) @[mem.scala 288:48]
    node _io_wdata_T_29 = bits(_io_wdata_T_28, 0, 0) @[Bitwise.scala 72:15]
    node io_wdata_hi_10 = mux(_io_wdata_T_29, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_wdata_T_30 = cat(io_wdata_hi_10, dmmod.io_out_1) @[Cat.scala 30:58]
    node _T_36 = eq(masksel_1, UInt<2>("h2")) @[mem.scala 289:24]
    node _io_wdata_T_31 = bits(dmmod.io_out_2, 7, 7) @[mem.scala 290:48]
    node _io_wdata_T_32 = bits(_io_wdata_T_31, 0, 0) @[Bitwise.scala 72:15]
    node io_wdata_hi_11 = mux(_io_wdata_T_32, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_wdata_T_33 = cat(io_wdata_hi_11, dmmod.io_out_2) @[Cat.scala 30:58]
    node _T_37 = eq(masksel_1, UInt<2>("h3")) @[mem.scala 291:24]
    node _io_wdata_T_34 = bits(dmmod.io_out_3, 7, 7) @[mem.scala 292:48]
    node _io_wdata_T_35 = bits(_io_wdata_T_34, 0, 0) @[Bitwise.scala 72:15]
    node io_wdata_hi_12 = mux(_io_wdata_T_35, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_wdata_T_36 = cat(io_wdata_hi_12, dmmod.io_out_3) @[Cat.scala 30:58]
    node _GEN_87 = mux(_T_37, _io_wdata_T_36, io_aluout) @[mem.scala 291:32 mem.scala 292:16 mem.scala 54:10]
    node _GEN_88 = mux(_T_36, _io_wdata_T_33, _GEN_87) @[mem.scala 289:32 mem.scala 290:16]
    node _GEN_89 = mux(_T_35, _io_wdata_T_30, _GEN_88) @[mem.scala 287:32 mem.scala 288:16]
    node _GEN_90 = mux(_T_34, _io_wdata_T_27, _GEN_89) @[mem.scala 285:27 mem.scala 286:16]
    node _T_38 = bits(io_instruction, 14, 12) @[mem.scala 296:30]
    node _T_39 = eq(_T_38, UInt<3>("h5")) @[mem.scala 296:38]
    node _T_40 = eq(masksel_1, UInt<1>("h0")) @[mem.scala 298:19]
    node _io_wdata_T_37 = bits(dmmod.io_out_1, 7, 7) @[mem.scala 299:48]
    node _io_wdata_T_38 = bits(_io_wdata_T_37, 0, 0) @[Bitwise.scala 72:15]
    node io_wdata_hi_hi_4 = mux(_io_wdata_T_38, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node io_wdata_hi_13 = cat(io_wdata_hi_hi_4, dmmod.io_out_1) @[Cat.scala 30:58]
    node _io_wdata_T_39 = cat(io_wdata_hi_13, dmmod.io_out_0) @[Cat.scala 30:58]
    node _T_41 = eq(masksel_1, UInt<1>("h1")) @[mem.scala 300:24]
    node _io_wdata_T_40 = bits(dmmod.io_out_2, 7, 7) @[mem.scala 301:48]
    node _io_wdata_T_41 = bits(_io_wdata_T_40, 0, 0) @[Bitwise.scala 72:15]
    node io_wdata_hi_hi_5 = mux(_io_wdata_T_41, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node io_wdata_hi_14 = cat(io_wdata_hi_hi_5, dmmod.io_out_2) @[Cat.scala 30:58]
    node _io_wdata_T_42 = cat(io_wdata_hi_14, dmmod.io_out_1) @[Cat.scala 30:58]
    node _T_42 = eq(masksel_1, UInt<2>("h2")) @[mem.scala 302:24]
    node _io_wdata_T_43 = bits(dmmod.io_out_3, 7, 7) @[mem.scala 303:48]
    node _io_wdata_T_44 = bits(_io_wdata_T_43, 0, 0) @[Bitwise.scala 72:15]
    node io_wdata_hi_hi_6 = mux(_io_wdata_T_44, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node io_wdata_hi_15 = cat(io_wdata_hi_hi_6, dmmod.io_out_3) @[Cat.scala 30:58]
    node _io_wdata_T_45 = cat(io_wdata_hi_15, dmmod.io_out_2) @[Cat.scala 30:58]
    node _T_43 = eq(masksel_1, UInt<2>("h3")) @[mem.scala 304:24]
    node _io_wdata_T_46 = bits(dmmod.io_out_0, 7, 7) @[mem.scala 305:48]
    node _io_wdata_T_47 = bits(_io_wdata_T_46, 0, 0) @[Bitwise.scala 72:15]
    node io_wdata_hi_hi_7 = mux(_io_wdata_T_47, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node io_wdata_hi_16 = cat(io_wdata_hi_hi_7, dmmod.io_out_0) @[Cat.scala 30:58]
    node _io_wdata_T_48 = cat(io_wdata_hi_16, dmmod.io_out_3) @[Cat.scala 30:58]
    node _GEN_91 = mux(_T_43, _io_wdata_T_48, io_aluout) @[mem.scala 304:32 mem.scala 305:16 mem.scala 54:10]
    node _GEN_92 = mux(_T_42, _io_wdata_T_45, _GEN_91) @[mem.scala 302:32 mem.scala 303:16]
    node _GEN_93 = mux(_T_41, _io_wdata_T_42, _GEN_92) @[mem.scala 300:32 mem.scala 301:16]
    node _GEN_94 = mux(_T_40, _io_wdata_T_39, _GEN_93) @[mem.scala 298:27 mem.scala 299:16]
    node _GEN_95 = mux(_T_39, _GEN_94, io_aluout) @[mem.scala 296:52 mem.scala 54:10]
    node _GEN_96 = mux(_T_33, _GEN_90, _GEN_95) @[mem.scala 283:52]
    node _GEN_97 = mux(_T_31, _io_wdata_T_24, _GEN_96) @[mem.scala 279:52 mem.scala 280:16]
    node _GEN_98 = mux(_T_25, _GEN_86, _GEN_97) @[mem.scala 265:52]
    node _GEN_99 = mux(_T_19, _GEN_82, _GEN_98) @[mem.scala 252:46]
    node _GEN_100 = mux(_T_17, UInt<1>("h0"), _GEN_66) @[mem.scala 242:38 mem.scala 243:8]
    node _GEN_101 = mux(_T_17, io_rdata1, _GEN_67) @[mem.scala 242:38 mem.scala 245:8]
    node _GEN_102 = mux(_T_17, io_imm, _GEN_68) @[mem.scala 242:38 mem.scala 246:8]
    node _GEN_103 = mux(_T_17, _dmmod_io_addr_T_1, _GEN_70) @[mem.scala 242:38 mem.scala 248:17]
    node _GEN_104 = mux(_T_17, UInt<1>("h1"), io_rd_enable) @[mem.scala 242:38 mem.scala 249:22 mem.scala 78:20]
    node _GEN_105 = mux(_T_17, _GEN_99, io_aluout) @[mem.scala 242:38 mem.scala 54:10]
    io_dataout_0 <= dmmod.io_out_0 @[mem.scala 312:11]
    io_dataout_1 <= dmmod.io_out_1 @[mem.scala 312:11]
    io_dataout_2 <= dmmod.io_out_2 @[mem.scala 312:11]
    io_dataout_3 <= dmmod.io_out_3 @[mem.scala 312:11]
    io_A <= _GEN_101
    io_B <= _GEN_102
    io_op <= _GEN_100
    io_wdata <= _GEN_105
    dmmod.clock <= clock
    dmmod.reset <= reset
    dmmod.io_addr <= _GEN_103
    dmmod.io_rd_enable <= _GEN_104
    dmmod.io_wr_enable <= _GEN_69
    dmmod.io_mask_0 <= _GEN_71
    dmmod.io_mask_1 <= _GEN_72
    dmmod.io_mask_2 <= _GEN_73
    dmmod.io_mask_3 <= _GEN_74
    dmmod.io_dataIn_0 <= _GEN_75
    dmmod.io_dataIn_1 <= _GEN_76
    dmmod.io_dataIn_2 <= _GEN_77
    dmmod.io_dataIn_3 <= _GEN_78

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

  module immgenr :
    input clock : Clock
    input reset : UInt<1>
    input io_instruction : UInt<32>
    output io_imm : UInt<32>

    node opcode = bits(io_instruction, 6, 0) @[immgenr.scala 24:30]
    node _T = eq(UInt<5>("h13"), opcode) @[Conditional.scala 37:30]
    node _io_imm_T = bits(io_instruction, 31, 31) @[immgenr.scala 27:44]
    node _io_imm_T_1 = bits(_io_imm_T, 0, 0) @[Bitwise.scala 72:15]
    node io_imm_hi = mux(_io_imm_T_1, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node io_imm_lo = bits(io_instruction, 31, 20) @[immgenr.scala 27:65]
    node _io_imm_T_2 = cat(io_imm_hi, io_imm_lo) @[Cat.scala 30:58]
    node _T_1 = eq(UInt<2>("h3"), opcode) @[Conditional.scala 37:30]
    node _io_imm_T_3 = bits(io_instruction, 31, 31) @[immgenr.scala 30:44]
    node _io_imm_T_4 = bits(_io_imm_T_3, 0, 0) @[Bitwise.scala 72:15]
    node io_imm_hi_1 = mux(_io_imm_T_4, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node io_imm_lo_1 = bits(io_instruction, 31, 20) @[immgenr.scala 30:65]
    node _io_imm_T_5 = cat(io_imm_hi_1, io_imm_lo_1) @[Cat.scala 30:58]
    node _T_2 = eq(UInt<6>("h23"), opcode) @[Conditional.scala 37:30]
    node _io_imm_T_6 = bits(io_instruction, 31, 31) @[immgenr.scala 33:44]
    node _io_imm_T_7 = bits(_io_imm_T_6, 0, 0) @[Bitwise.scala 72:15]
    node io_imm_hi_hi = mux(_io_imm_T_7, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node io_imm_hi_lo = bits(io_instruction, 31, 25) @[immgenr.scala 33:65]
    node io_imm_lo_2 = bits(io_instruction, 11, 7) @[immgenr.scala 33:89]
    node io_imm_hi_2 = cat(io_imm_hi_hi, io_imm_hi_lo) @[Cat.scala 30:58]
    node _io_imm_T_8 = cat(io_imm_hi_2, io_imm_lo_2) @[Cat.scala 30:58]
    node _T_3 = eq(UInt<7>("h63"), opcode) @[Conditional.scala 37:30]
    node _io_imm_T_9 = bits(io_instruction, 31, 31) @[immgenr.scala 36:44]
    node _io_imm_T_10 = bits(_io_imm_T_9, 0, 0) @[Bitwise.scala 72:15]
    node io_imm_hi_hi_hi = mux(_io_imm_T_10, UInt<19>("h7ffff"), UInt<19>("h0")) @[Bitwise.scala 72:12]
    node io_imm_hi_hi_lo = bits(io_instruction, 31, 31) @[immgenr.scala 36:65]
    node io_imm_hi_lo_1 = bits(io_instruction, 7, 7) @[immgenr.scala 36:85]
    node io_imm_lo_hi_hi = bits(io_instruction, 30, 25) @[immgenr.scala 36:104]
    node io_imm_lo_hi_lo = bits(io_instruction, 11, 8) @[immgenr.scala 36:127]
    node io_imm_lo_hi = cat(io_imm_lo_hi_hi, io_imm_lo_hi_lo) @[Cat.scala 30:58]
    node io_imm_lo_3 = cat(io_imm_lo_hi, UInt<1>("h0")) @[Cat.scala 30:58]
    node io_imm_hi_hi_1 = cat(io_imm_hi_hi_hi, io_imm_hi_hi_lo) @[Cat.scala 30:58]
    node io_imm_hi_3 = cat(io_imm_hi_hi_1, io_imm_hi_lo_1) @[Cat.scala 30:58]
    node _io_imm_T_11 = cat(io_imm_hi_3, io_imm_lo_3) @[Cat.scala 30:58]
    node _T_4 = eq(UInt<6>("h37"), opcode) @[Conditional.scala 37:30]
    node io_imm_hi_4 = bits(io_instruction, 31, 12) @[immgenr.scala 40:35]
    node io_imm_lo_4 = mux(UInt<1>("h0"), UInt<12>("hfff"), UInt<12>("h0")) @[Bitwise.scala 72:12]
    node _io_imm_T_12 = cat(io_imm_hi_4, io_imm_lo_4) @[Cat.scala 30:58]
    node _T_5 = eq(UInt<32>("h17"), opcode) @[Conditional.scala 37:30]
    node io_imm_hi_5 = bits(io_instruction, 31, 12) @[immgenr.scala 43:35]
    node io_imm_lo_5 = mux(UInt<1>("h0"), UInt<12>("hfff"), UInt<12>("h0")) @[Bitwise.scala 72:12]
    node _io_imm_T_13 = cat(io_imm_hi_5, io_imm_lo_5) @[Cat.scala 30:58]
    node _T_6 = eq(UInt<32>("h6f"), opcode) @[Conditional.scala 37:30]
    node _io_imm_T_14 = bits(io_instruction, 31, 31) @[immgenr.scala 49:44]
    node _io_imm_T_15 = bits(_io_imm_T_14, 0, 0) @[Bitwise.scala 72:15]
    node io_imm_hi_hi_hi_1 = mux(_io_imm_T_15, UInt<11>("h7ff"), UInt<11>("h0")) @[Bitwise.scala 72:12]
    node io_imm_hi_hi_lo_1 = bits(io_instruction, 31, 31) @[immgenr.scala 49:65]
    node io_imm_hi_lo_2 = bits(io_instruction, 19, 12) @[immgenr.scala 49:85]
    node io_imm_lo_hi_hi_1 = bits(io_instruction, 20, 20) @[immgenr.scala 49:109]
    node io_imm_lo_hi_lo_1 = bits(io_instruction, 30, 21) @[immgenr.scala 49:129]
    node io_imm_lo_hi_1 = cat(io_imm_lo_hi_hi_1, io_imm_lo_hi_lo_1) @[Cat.scala 30:58]
    node io_imm_lo_6 = cat(io_imm_lo_hi_1, UInt<1>("h0")) @[Cat.scala 30:58]
    node io_imm_hi_hi_2 = cat(io_imm_hi_hi_hi_1, io_imm_hi_hi_lo_1) @[Cat.scala 30:58]
    node io_imm_hi_6 = cat(io_imm_hi_hi_2, io_imm_hi_lo_2) @[Cat.scala 30:58]
    node _io_imm_T_16 = cat(io_imm_hi_6, io_imm_lo_6) @[Cat.scala 30:58]
    node _T_7 = eq(UInt<32>("h67"), opcode) @[Conditional.scala 37:30]
    node _io_imm_T_17 = bits(io_instruction, 31, 31) @[immgenr.scala 53:44]
    node _io_imm_T_18 = bits(_io_imm_T_17, 0, 0) @[Bitwise.scala 72:15]
    node io_imm_hi_7 = mux(_io_imm_T_18, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node io_imm_lo_7 = bits(io_instruction, 31, 20) @[immgenr.scala 53:65]
    node _io_imm_T_19 = cat(io_imm_hi_7, io_imm_lo_7) @[Cat.scala 30:58]
    node _GEN_0 = mux(_T_7, _io_imm_T_19, UInt<1>("h0")) @[Conditional.scala 39:67 immgenr.scala 53:14 immgenr.scala 23:10]
    node _GEN_1 = mux(_T_6, _io_imm_T_16, _GEN_0) @[Conditional.scala 39:67 immgenr.scala 49:14]
    node _GEN_2 = mux(_T_5, _io_imm_T_13, _GEN_1) @[Conditional.scala 39:67 immgenr.scala 43:14]
    node _GEN_3 = mux(_T_4, _io_imm_T_12, _GEN_2) @[Conditional.scala 39:67 immgenr.scala 40:14]
    node _GEN_4 = mux(_T_3, _io_imm_T_11, _GEN_3) @[Conditional.scala 39:67 immgenr.scala 36:14]
    node _GEN_5 = mux(_T_2, _io_imm_T_8, _GEN_4) @[Conditional.scala 39:67 immgenr.scala 33:14]
    node _GEN_6 = mux(_T_1, _io_imm_T_5, _GEN_5) @[Conditional.scala 39:67 immgenr.scala 30:14]
    node _GEN_7 = mux(_T, _io_imm_T_2, _GEN_6) @[Conditional.scala 40:58 immgenr.scala 27:14]
    io_imm <= _GEN_7

  module registerfile :
    input clock : Clock
    input reset : UInt<1>
    input io_raddr1 : UInt<5>
    input io_raddr2 : UInt<5>
    output io_rdata1 : UInt<32>
    output io_rdata2 : UInt<32>
    input io_wen : UInt<1>
    input io_waddr : UInt<5>
    input io_wdata : UInt<32>

    reg regs_0 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_0) @[registerfile.scala 14:16]
    reg regs_1 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_1) @[registerfile.scala 14:16]
    reg regs_2 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_2) @[registerfile.scala 14:16]
    reg regs_3 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_3) @[registerfile.scala 14:16]
    reg regs_4 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_4) @[registerfile.scala 14:16]
    reg regs_5 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_5) @[registerfile.scala 14:16]
    reg regs_6 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_6) @[registerfile.scala 14:16]
    reg regs_7 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_7) @[registerfile.scala 14:16]
    reg regs_8 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_8) @[registerfile.scala 14:16]
    reg regs_9 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_9) @[registerfile.scala 14:16]
    reg regs_10 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_10) @[registerfile.scala 14:16]
    reg regs_11 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_11) @[registerfile.scala 14:16]
    reg regs_12 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_12) @[registerfile.scala 14:16]
    reg regs_13 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_13) @[registerfile.scala 14:16]
    reg regs_14 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_14) @[registerfile.scala 14:16]
    reg regs_15 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_15) @[registerfile.scala 14:16]
    reg regs_16 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_16) @[registerfile.scala 14:16]
    reg regs_17 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_17) @[registerfile.scala 14:16]
    reg regs_18 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_18) @[registerfile.scala 14:16]
    reg regs_19 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_19) @[registerfile.scala 14:16]
    reg regs_20 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_20) @[registerfile.scala 14:16]
    reg regs_21 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_21) @[registerfile.scala 14:16]
    reg regs_22 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_22) @[registerfile.scala 14:16]
    reg regs_23 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_23) @[registerfile.scala 14:16]
    reg regs_24 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_24) @[registerfile.scala 14:16]
    reg regs_25 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_25) @[registerfile.scala 14:16]
    reg regs_26 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_26) @[registerfile.scala 14:16]
    reg regs_27 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_27) @[registerfile.scala 14:16]
    reg regs_28 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_28) @[registerfile.scala 14:16]
    reg regs_29 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_29) @[registerfile.scala 14:16]
    reg regs_30 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_30) @[registerfile.scala 14:16]
    reg regs_31 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_31) @[registerfile.scala 14:16]
    node _io_rdata1_T = orr(io_raddr1) @[registerfile.scala 15:37]
    node _GEN_0 = validif(eq(UInt<1>("h0"), io_raddr1), regs_0) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_1 = mux(eq(UInt<1>("h1"), io_raddr1), regs_1, _GEN_0) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_2 = mux(eq(UInt<2>("h2"), io_raddr1), regs_2, _GEN_1) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_3 = mux(eq(UInt<2>("h3"), io_raddr1), regs_3, _GEN_2) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_4 = mux(eq(UInt<3>("h4"), io_raddr1), regs_4, _GEN_3) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_5 = mux(eq(UInt<3>("h5"), io_raddr1), regs_5, _GEN_4) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_6 = mux(eq(UInt<3>("h6"), io_raddr1), regs_6, _GEN_5) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_7 = mux(eq(UInt<3>("h7"), io_raddr1), regs_7, _GEN_6) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_8 = mux(eq(UInt<4>("h8"), io_raddr1), regs_8, _GEN_7) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_9 = mux(eq(UInt<4>("h9"), io_raddr1), regs_9, _GEN_8) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_10 = mux(eq(UInt<4>("ha"), io_raddr1), regs_10, _GEN_9) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_11 = mux(eq(UInt<4>("hb"), io_raddr1), regs_11, _GEN_10) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_12 = mux(eq(UInt<4>("hc"), io_raddr1), regs_12, _GEN_11) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_13 = mux(eq(UInt<4>("hd"), io_raddr1), regs_13, _GEN_12) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_14 = mux(eq(UInt<4>("he"), io_raddr1), regs_14, _GEN_13) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_15 = mux(eq(UInt<4>("hf"), io_raddr1), regs_15, _GEN_14) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_16 = mux(eq(UInt<5>("h10"), io_raddr1), regs_16, _GEN_15) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_17 = mux(eq(UInt<5>("h11"), io_raddr1), regs_17, _GEN_16) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_18 = mux(eq(UInt<5>("h12"), io_raddr1), regs_18, _GEN_17) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_19 = mux(eq(UInt<5>("h13"), io_raddr1), regs_19, _GEN_18) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_20 = mux(eq(UInt<5>("h14"), io_raddr1), regs_20, _GEN_19) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_21 = mux(eq(UInt<5>("h15"), io_raddr1), regs_21, _GEN_20) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_22 = mux(eq(UInt<5>("h16"), io_raddr1), regs_22, _GEN_21) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_23 = mux(eq(UInt<5>("h17"), io_raddr1), regs_23, _GEN_22) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_24 = mux(eq(UInt<5>("h18"), io_raddr1), regs_24, _GEN_23) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_25 = mux(eq(UInt<5>("h19"), io_raddr1), regs_25, _GEN_24) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_26 = mux(eq(UInt<5>("h1a"), io_raddr1), regs_26, _GEN_25) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_27 = mux(eq(UInt<5>("h1b"), io_raddr1), regs_27, _GEN_26) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_28 = mux(eq(UInt<5>("h1c"), io_raddr1), regs_28, _GEN_27) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_29 = mux(eq(UInt<5>("h1d"), io_raddr1), regs_29, _GEN_28) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_30 = mux(eq(UInt<5>("h1e"), io_raddr1), regs_30, _GEN_29) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _GEN_31 = mux(eq(UInt<5>("h1f"), io_raddr1), regs_31, _GEN_30) @[registerfile.scala 15:20 registerfile.scala 15:20]
    node _regs_io_raddr1 = _GEN_31 @[registerfile.scala 15:20]
    node _io_rdata1_T_1 = mux(_io_rdata1_T, _regs_io_raddr1, UInt<1>("h0")) @[registerfile.scala 15:20]
    node _io_rdata2_T = orr(io_raddr2) @[registerfile.scala 16:37]
    node _GEN_32 = validif(eq(UInt<1>("h0"), io_raddr2), regs_0) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_33 = mux(eq(UInt<1>("h1"), io_raddr2), regs_1, _GEN_32) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_34 = mux(eq(UInt<2>("h2"), io_raddr2), regs_2, _GEN_33) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_35 = mux(eq(UInt<2>("h3"), io_raddr2), regs_3, _GEN_34) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_36 = mux(eq(UInt<3>("h4"), io_raddr2), regs_4, _GEN_35) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_37 = mux(eq(UInt<3>("h5"), io_raddr2), regs_5, _GEN_36) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_38 = mux(eq(UInt<3>("h6"), io_raddr2), regs_6, _GEN_37) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_39 = mux(eq(UInt<3>("h7"), io_raddr2), regs_7, _GEN_38) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_40 = mux(eq(UInt<4>("h8"), io_raddr2), regs_8, _GEN_39) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_41 = mux(eq(UInt<4>("h9"), io_raddr2), regs_9, _GEN_40) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_42 = mux(eq(UInt<4>("ha"), io_raddr2), regs_10, _GEN_41) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_43 = mux(eq(UInt<4>("hb"), io_raddr2), regs_11, _GEN_42) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_44 = mux(eq(UInt<4>("hc"), io_raddr2), regs_12, _GEN_43) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_45 = mux(eq(UInt<4>("hd"), io_raddr2), regs_13, _GEN_44) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_46 = mux(eq(UInt<4>("he"), io_raddr2), regs_14, _GEN_45) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_47 = mux(eq(UInt<4>("hf"), io_raddr2), regs_15, _GEN_46) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_48 = mux(eq(UInt<5>("h10"), io_raddr2), regs_16, _GEN_47) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_49 = mux(eq(UInt<5>("h11"), io_raddr2), regs_17, _GEN_48) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_50 = mux(eq(UInt<5>("h12"), io_raddr2), regs_18, _GEN_49) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_51 = mux(eq(UInt<5>("h13"), io_raddr2), regs_19, _GEN_50) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_52 = mux(eq(UInt<5>("h14"), io_raddr2), regs_20, _GEN_51) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_53 = mux(eq(UInt<5>("h15"), io_raddr2), regs_21, _GEN_52) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_54 = mux(eq(UInt<5>("h16"), io_raddr2), regs_22, _GEN_53) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_55 = mux(eq(UInt<5>("h17"), io_raddr2), regs_23, _GEN_54) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_56 = mux(eq(UInt<5>("h18"), io_raddr2), regs_24, _GEN_55) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_57 = mux(eq(UInt<5>("h19"), io_raddr2), regs_25, _GEN_56) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_58 = mux(eq(UInt<5>("h1a"), io_raddr2), regs_26, _GEN_57) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_59 = mux(eq(UInt<5>("h1b"), io_raddr2), regs_27, _GEN_58) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_60 = mux(eq(UInt<5>("h1c"), io_raddr2), regs_28, _GEN_59) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_61 = mux(eq(UInt<5>("h1d"), io_raddr2), regs_29, _GEN_60) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_62 = mux(eq(UInt<5>("h1e"), io_raddr2), regs_30, _GEN_61) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _GEN_63 = mux(eq(UInt<5>("h1f"), io_raddr2), regs_31, _GEN_62) @[registerfile.scala 16:20 registerfile.scala 16:20]
    node _regs_io_raddr2 = _GEN_63 @[registerfile.scala 16:20]
    node _io_rdata2_T_1 = mux(_io_rdata2_T, _regs_io_raddr2, UInt<1>("h0")) @[registerfile.scala 16:20]
    node _T = orr(io_waddr) @[registerfile.scala 17:32]
    node _T_1 = and(io_wen, _T) @[registerfile.scala 17:17]
    node _regs_io_waddr = io_wdata @[registerfile.scala 18:25 registerfile.scala 18:25]
    node _GEN_64 = mux(eq(UInt<1>("h0"), io_waddr), _regs_io_waddr, regs_0) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_65 = mux(eq(UInt<1>("h1"), io_waddr), _regs_io_waddr, regs_1) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_66 = mux(eq(UInt<2>("h2"), io_waddr), _regs_io_waddr, regs_2) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_67 = mux(eq(UInt<2>("h3"), io_waddr), _regs_io_waddr, regs_3) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_68 = mux(eq(UInt<3>("h4"), io_waddr), _regs_io_waddr, regs_4) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_69 = mux(eq(UInt<3>("h5"), io_waddr), _regs_io_waddr, regs_5) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_70 = mux(eq(UInt<3>("h6"), io_waddr), _regs_io_waddr, regs_6) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_71 = mux(eq(UInt<3>("h7"), io_waddr), _regs_io_waddr, regs_7) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_72 = mux(eq(UInt<4>("h8"), io_waddr), _regs_io_waddr, regs_8) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_73 = mux(eq(UInt<4>("h9"), io_waddr), _regs_io_waddr, regs_9) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_74 = mux(eq(UInt<4>("ha"), io_waddr), _regs_io_waddr, regs_10) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_75 = mux(eq(UInt<4>("hb"), io_waddr), _regs_io_waddr, regs_11) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_76 = mux(eq(UInt<4>("hc"), io_waddr), _regs_io_waddr, regs_12) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_77 = mux(eq(UInt<4>("hd"), io_waddr), _regs_io_waddr, regs_13) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_78 = mux(eq(UInt<4>("he"), io_waddr), _regs_io_waddr, regs_14) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_79 = mux(eq(UInt<4>("hf"), io_waddr), _regs_io_waddr, regs_15) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_80 = mux(eq(UInt<5>("h10"), io_waddr), _regs_io_waddr, regs_16) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_81 = mux(eq(UInt<5>("h11"), io_waddr), _regs_io_waddr, regs_17) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_82 = mux(eq(UInt<5>("h12"), io_waddr), _regs_io_waddr, regs_18) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_83 = mux(eq(UInt<5>("h13"), io_waddr), _regs_io_waddr, regs_19) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_84 = mux(eq(UInt<5>("h14"), io_waddr), _regs_io_waddr, regs_20) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_85 = mux(eq(UInt<5>("h15"), io_waddr), _regs_io_waddr, regs_21) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_86 = mux(eq(UInt<5>("h16"), io_waddr), _regs_io_waddr, regs_22) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_87 = mux(eq(UInt<5>("h17"), io_waddr), _regs_io_waddr, regs_23) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_88 = mux(eq(UInt<5>("h18"), io_waddr), _regs_io_waddr, regs_24) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_89 = mux(eq(UInt<5>("h19"), io_waddr), _regs_io_waddr, regs_25) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_90 = mux(eq(UInt<5>("h1a"), io_waddr), _regs_io_waddr, regs_26) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_91 = mux(eq(UInt<5>("h1b"), io_waddr), _regs_io_waddr, regs_27) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_92 = mux(eq(UInt<5>("h1c"), io_waddr), _regs_io_waddr, regs_28) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_93 = mux(eq(UInt<5>("h1d"), io_waddr), _regs_io_waddr, regs_29) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_94 = mux(eq(UInt<5>("h1e"), io_waddr), _regs_io_waddr, regs_30) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_95 = mux(eq(UInt<5>("h1f"), io_waddr), _regs_io_waddr, regs_31) @[registerfile.scala 18:25 registerfile.scala 18:25 registerfile.scala 14:16]
    node _GEN_96 = mux(_T_1, _GEN_64, regs_0) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_97 = mux(_T_1, _GEN_65, regs_1) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_98 = mux(_T_1, _GEN_66, regs_2) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_99 = mux(_T_1, _GEN_67, regs_3) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_100 = mux(_T_1, _GEN_68, regs_4) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_101 = mux(_T_1, _GEN_69, regs_5) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_102 = mux(_T_1, _GEN_70, regs_6) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_103 = mux(_T_1, _GEN_71, regs_7) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_104 = mux(_T_1, _GEN_72, regs_8) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_105 = mux(_T_1, _GEN_73, regs_9) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_106 = mux(_T_1, _GEN_74, regs_10) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_107 = mux(_T_1, _GEN_75, regs_11) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_108 = mux(_T_1, _GEN_76, regs_12) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_109 = mux(_T_1, _GEN_77, regs_13) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_110 = mux(_T_1, _GEN_78, regs_14) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_111 = mux(_T_1, _GEN_79, regs_15) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_112 = mux(_T_1, _GEN_80, regs_16) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_113 = mux(_T_1, _GEN_81, regs_17) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_114 = mux(_T_1, _GEN_82, regs_18) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_115 = mux(_T_1, _GEN_83, regs_19) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_116 = mux(_T_1, _GEN_84, regs_20) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_117 = mux(_T_1, _GEN_85, regs_21) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_118 = mux(_T_1, _GEN_86, regs_22) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_119 = mux(_T_1, _GEN_87, regs_23) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_120 = mux(_T_1, _GEN_88, regs_24) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_121 = mux(_T_1, _GEN_89, regs_25) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_122 = mux(_T_1, _GEN_90, regs_26) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_123 = mux(_T_1, _GEN_91, regs_27) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_124 = mux(_T_1, _GEN_92, regs_28) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_125 = mux(_T_1, _GEN_93, regs_29) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_126 = mux(_T_1, _GEN_94, regs_30) @[registerfile.scala 17:38 registerfile.scala 14:16]
    node _GEN_127 = mux(_T_1, _GEN_95, regs_31) @[registerfile.scala 17:38 registerfile.scala 14:16]
    io_rdata1 <= _io_rdata1_T_1 @[registerfile.scala 15:13]
    io_rdata2 <= _io_rdata2_T_1 @[registerfile.scala 16:13]
    regs_0 <= _GEN_96
    regs_1 <= _GEN_97
    regs_2 <= _GEN_98
    regs_3 <= _GEN_99
    regs_4 <= _GEN_100
    regs_5 <= _GEN_101
    regs_6 <= _GEN_102
    regs_7 <= _GEN_103
    regs_8 <= _GEN_104
    regs_9 <= _GEN_105
    regs_10 <= _GEN_106
    regs_11 <= _GEN_107
    regs_12 <= _GEN_108
    regs_13 <= _GEN_109
    regs_14 <= _GEN_110
    regs_15 <= _GEN_111
    regs_16 <= _GEN_112
    regs_17 <= _GEN_113
    regs_18 <= _GEN_114
    regs_19 <= _GEN_115
    regs_20 <= _GEN_116
    regs_21 <= _GEN_117
    regs_22 <= _GEN_118
    regs_23 <= _GEN_119
    regs_24 <= _GEN_120
    regs_25 <= _GEN_121
    regs_26 <= _GEN_122
    regs_27 <= _GEN_123
    regs_28 <= _GEN_124
    regs_29 <= _GEN_125
    regs_30 <= _GEN_126
    regs_31 <= _GEN_127

  module decode :
    input clock : Clock
    input reset : UInt<1>
    output io_rdata1 : UInt<32>
    output io_rdata2 : UInt<32>
    input io_wdata : UInt<32>
    input io_instructioncu : UInt<32>
    output io_func3_7 : UInt<4>
    output io_en_imem : UInt<1>
    output io_immg : UInt<32>

    inst cumod of controlunit @[decode.scala 43:19]
    inst immg of immgenr @[decode.scala 44:18]
    inst regfmod of registerfile @[decode.scala 45:21]
    io_rdata1 <= regfmod.io_rdata1 @[decode.scala 67:11]
    io_rdata2 <= regfmod.io_rdata2 @[decode.scala 68:11]
    io_func3_7 <= cumod.io_func3_7 @[decode.scala 56:11]
    io_en_imem <= cumod.io_en_imem @[decode.scala 57:12]
    io_immg <= immg.io_imm @[decode.scala 79:8]
    cumod.clock <= clock
    cumod.reset <= reset
    cumod.io_instruction <= io_instructioncu @[decode.scala 55:21]
    immg.clock <= clock
    immg.reset <= reset
    immg.io_instruction <= io_instructioncu @[decode.scala 77:20]
    regfmod.clock <= clock
    regfmod.reset <= reset
    regfmod.io_raddr1 <= cumod.io_rs1 @[decode.scala 49:19]
    regfmod.io_raddr2 <= cumod.io_rs2 @[decode.scala 50:19]
    regfmod.io_wen <= cumod.io_en_reg @[decode.scala 69:15]
    regfmod.io_waddr <= cumod.io_rd @[decode.scala 51:18]
    regfmod.io_wdata <= io_wdata @[decode.scala 71:17]

  module topcore :
    input clock : Clock
    input reset : UInt<1>
    output io_out : UInt<32>

    inst fetchmod of fetch @[topcore.scala 14:22]
    inst executemod of execute @[topcore.scala 16:24]
    inst wbmod of wb @[topcore.scala 18:18]
    inst memmod of mem @[topcore.scala 20:20]
    inst decodemod of decode @[topcore.scala 22:23]
    node _myVector_0_T = bits(decodemod.io_rdata2, 7, 0) @[topcore.scala 96:33]
    node _myVector_1_T = bits(decodemod.io_rdata2, 15, 7) @[topcore.scala 97:33]
    node _myVector_2_T = bits(decodemod.io_rdata2, 23, 15) @[topcore.scala 98:33]
    node _myVector_3_T = bits(decodemod.io_rdata2, 31, 23) @[topcore.scala 99:33]
    node _T = bits(fetchmod.io_insout, 6, 0) @[topcore.scala 107:24]
    node _T_1 = eq(_T, UInt<2>("h3")) @[topcore.scala 107:30]
    node _T_2 = bits(fetchmod.io_insout, 6, 0) @[topcore.scala 110:30]
    node _T_3 = eq(_T_2, UInt<6>("h23")) @[topcore.scala 110:35]
    node _GEN_0 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[topcore.scala 111:1 topcore.scala 112:24 topcore.scala 105:22]
    node _GEN_1 = mux(_T_1, UInt<1>("h1"), _GEN_0) @[topcore.scala 108:1 topcore.scala 109:24]
    node _GEN_2 = mux(_T_1, UInt<1>("h0"), _GEN_0) @[topcore.scala 108:1 topcore.scala 106:22]
    node wbmod_io_datamemin_lo = cat(memmod.io_dataout_1, memmod.io_dataout_0) @[Cat.scala 30:58]
    node wbmod_io_datamemin_hi = cat(memmod.io_dataout_3, memmod.io_dataout_2) @[Cat.scala 30:58]
    node _wbmod_io_datamemin_T = cat(wbmod_io_datamemin_hi, wbmod_io_datamemin_lo) @[Cat.scala 30:58]
    node myVector_0 = _myVector_0_T @[topcore.scala 95:21 topcore.scala 96:12]
    node myVector_1 = bits(_myVector_1_T, 7, 0) @[topcore.scala 95:21 topcore.scala 97:12]
    node myVector_2 = bits(_myVector_2_T, 7, 0) @[topcore.scala 95:21 topcore.scala 98:12]
    node myVector_3 = bits(_myVector_3_T, 7, 0) @[topcore.scala 95:21 topcore.scala 99:12]
    io_out <= decodemod.io_wdata @[topcore.scala 143:7]
    fetchmod.clock <= clock
    fetchmod.reset <= reset
    fetchmod.io_imm <= executemod.io_aluout @[topcore.scala 89:16]
    fetchmod.io_jump <= executemod.io_pcjump @[topcore.scala 90:17]
    fetchmod.io_jump2 <= executemod.io_pcjump2 @[topcore.scala 91:18]
    fetchmod.io_jump3 <= executemod.io_pcjump3 @[topcore.scala 92:18]
    fetchmod.io_data_in <= UInt<1>("h0") @[topcore.scala 75:21]
    fetchmod.io_enable <= UInt<1>("h1") @[topcore.scala 73:21]
    executemod.clock <= clock
    executemod.reset <= reset
    executemod.io_A <= memmod.io_A @[topcore.scala 118:16]
    executemod.io_B <= memmod.io_B @[topcore.scala 119:16]
    executemod.io_op <= memmod.io_op @[topcore.scala 120:17]
    executemod.io_rdata1 <= decodemod.io_rdata1 @[topcore.scala 80:21]
    executemod.io_rdata2 <= decodemod.io_rdata2 @[topcore.scala 81:21]
    executemod.io_instructioncu <= decodemod.io_instructioncu @[topcore.scala 83:28]
    executemod.io_func3_7 <= bits(decodemod.io_func3_7, 2, 0) @[topcore.scala 84:22]
    executemod.io_immg <= decodemod.io_immg @[topcore.scala 85:19]
    executemod.io_pcout <= fetchmod.io_pcout @[topcore.scala 86:20]
    wbmod.clock <= clock
    wbmod.reset <= reset
    wbmod.io_datamemin <= _wbmod_io_datamemin_T @[topcore.scala 141:21]
    wbmod.io_ins <= fetchmod.io_insout @[topcore.scala 134:17]
    memmod.clock <= clock
    memmod.reset <= reset
    memmod.io_rd_enable <= _GEN_1
    memmod.io_wr_enable <= _GEN_2
    memmod.io_dataIn_0 <= myVector_0 @[topcore.scala 102:17]
    memmod.io_dataIn_1 <= myVector_1 @[topcore.scala 102:17]
    memmod.io_dataIn_2 <= myVector_2 @[topcore.scala 102:17]
    memmod.io_dataIn_3 <= myVector_3 @[topcore.scala 102:17]
    memmod.io_instruction <= fetchmod.io_insout @[topcore.scala 115:22]
    memmod.io_aluout <= executemod.io_aluout @[topcore.scala 122:17]
    memmod.io_imm <= decodemod.io_immg @[topcore.scala 124:14]
    memmod.io_rdata1 <= decodemod.io_rdata1 @[topcore.scala 127:18]
    memmod.io_rdata2 <= decodemod.io_rdata2 @[topcore.scala 129:17]
    decodemod.clock <= clock
    decodemod.reset <= reset
    decodemod.io_wdata <= executemod.io_wdata @[topcore.scala 138:19]
    decodemod.io_instructioncu <= fetchmod.io_insout @[topcore.scala 70:29]
