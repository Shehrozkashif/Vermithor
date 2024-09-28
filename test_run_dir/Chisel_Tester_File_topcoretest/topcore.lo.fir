circuit topcore :
  module pc :
    input clock : Clock
    input reset : UInt<1>
    input io_imm : UInt<32>
    output io_out : UInt<32>
    input io_jump : UInt<1>

    reg pc : UInt<32>, clock with :
      reset => (UInt<1>("h0"), pc) @[pc.scala 20:19]
    node _pc_T = add(pc, UInt<3>("h4")) @[pc.scala 26:11]
    node _pc_T_1 = tail(_pc_T, 1) @[pc.scala 26:11]
    node _GEN_0 = mux(io_jump, io_imm, _pc_T_1) @[pc.scala 22:14 pc.scala 23:4 pc.scala 26:4]
    io_out <= pc @[pc.scala 29:8]
    pc <= mux(reset, UInt<32>("h0"), _GEN_0) @[pc.scala 20:19 pc.scala 20:19]

  module Imem :
    input clock : Clock
    input reset : UInt<1>
    input io_address : UInt<32>
    output io_out : UInt<32>

    mem memory : @[Imem.scala 11:17]
      data-type => UInt<32>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => io_out_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = shr(io_address, 2) @[Imem.scala 17:26]
    node _T_1 = bits(_T, 9, 0)
    node _io_out_T = shr(io_address, 2) @[Imem.scala 19:35]
    node _io_out_T_1 = bits(_io_out_T, 9, 0) @[Imem.scala 19:22]
    io_out <= memory.io_out_MPORT.data @[Imem.scala 19:8]
    memory.io_out_MPORT.addr <= _io_out_T_1 @[Imem.scala 19:22]
    memory.io_out_MPORT.en <= UInt<1>("h1") @[Imem.scala 19:22]
    memory.io_out_MPORT.clk <= clock @[Imem.scala 19:22]
    memory.MPORT.addr <= _T_1
    memory.MPORT.en <= UInt<1>("h1")
    memory.MPORT.clk <= clock
    memory.MPORT.data <= UInt<1>("h0")
    memory.MPORT.mask <= UInt<1>("h1")

  module fetch :
    input clock : Clock
    input reset : UInt<1>
    output io_pc_fetch_out : UInt<32>
    output io_Imem_fetch_out : UInt<32>
    input io_pc_imm_execute : UInt<32>
    input io_jump_fetch : UInt<1>

    inst pcmod of pc @[fetch.scala 30:23]
    inst inmmod of Imem @[fetch.scala 31:24]
    io_pc_fetch_out <= pcmod.io_out @[fetch.scala 49:21]
    io_Imem_fetch_out <= inmmod.io_out @[fetch.scala 53:23]
    pcmod.clock <= clock
    pcmod.reset <= reset
    pcmod.io_imm <= io_pc_imm_execute @[fetch.scala 44:18]
    pcmod.io_jump <= io_jump_fetch @[fetch.scala 56:23]
    inmmod.clock <= clock
    inmmod.reset <= reset
    inmmod.io_address <= pcmod.io_out @[fetch.scala 40:23]

  module controlunit :
    input clock : Clock
    input reset : UInt<1>
    input io_instruction : UInt<32>
    output io_func3_7 : UInt<3>
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
    node _io_rdata1_T = orr(io_raddr1) @[registerfile.scala 15:35]
    node _GEN_0 = validif(eq(UInt<1>("h0"), io_raddr1), regs_0) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_1 = mux(eq(UInt<1>("h1"), io_raddr1), regs_1, _GEN_0) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_2 = mux(eq(UInt<2>("h2"), io_raddr1), regs_2, _GEN_1) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_3 = mux(eq(UInt<2>("h3"), io_raddr1), regs_3, _GEN_2) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_4 = mux(eq(UInt<3>("h4"), io_raddr1), regs_4, _GEN_3) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_5 = mux(eq(UInt<3>("h5"), io_raddr1), regs_5, _GEN_4) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_6 = mux(eq(UInt<3>("h6"), io_raddr1), regs_6, _GEN_5) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_7 = mux(eq(UInt<3>("h7"), io_raddr1), regs_7, _GEN_6) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_8 = mux(eq(UInt<4>("h8"), io_raddr1), regs_8, _GEN_7) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_9 = mux(eq(UInt<4>("h9"), io_raddr1), regs_9, _GEN_8) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_10 = mux(eq(UInt<4>("ha"), io_raddr1), regs_10, _GEN_9) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_11 = mux(eq(UInt<4>("hb"), io_raddr1), regs_11, _GEN_10) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_12 = mux(eq(UInt<4>("hc"), io_raddr1), regs_12, _GEN_11) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_13 = mux(eq(UInt<4>("hd"), io_raddr1), regs_13, _GEN_12) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_14 = mux(eq(UInt<4>("he"), io_raddr1), regs_14, _GEN_13) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_15 = mux(eq(UInt<4>("hf"), io_raddr1), regs_15, _GEN_14) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_16 = mux(eq(UInt<5>("h10"), io_raddr1), regs_16, _GEN_15) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_17 = mux(eq(UInt<5>("h11"), io_raddr1), regs_17, _GEN_16) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_18 = mux(eq(UInt<5>("h12"), io_raddr1), regs_18, _GEN_17) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_19 = mux(eq(UInt<5>("h13"), io_raddr1), regs_19, _GEN_18) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_20 = mux(eq(UInt<5>("h14"), io_raddr1), regs_20, _GEN_19) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_21 = mux(eq(UInt<5>("h15"), io_raddr1), regs_21, _GEN_20) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_22 = mux(eq(UInt<5>("h16"), io_raddr1), regs_22, _GEN_21) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_23 = mux(eq(UInt<5>("h17"), io_raddr1), regs_23, _GEN_22) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_24 = mux(eq(UInt<5>("h18"), io_raddr1), regs_24, _GEN_23) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_25 = mux(eq(UInt<5>("h19"), io_raddr1), regs_25, _GEN_24) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_26 = mux(eq(UInt<5>("h1a"), io_raddr1), regs_26, _GEN_25) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_27 = mux(eq(UInt<5>("h1b"), io_raddr1), regs_27, _GEN_26) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_28 = mux(eq(UInt<5>("h1c"), io_raddr1), regs_28, _GEN_27) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_29 = mux(eq(UInt<5>("h1d"), io_raddr1), regs_29, _GEN_28) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_30 = mux(eq(UInt<5>("h1e"), io_raddr1), regs_30, _GEN_29) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _GEN_31 = mux(eq(UInt<5>("h1f"), io_raddr1), regs_31, _GEN_30) @[registerfile.scala 15:18 registerfile.scala 15:18]
    node _regs_io_raddr1 = _GEN_31 @[registerfile.scala 15:18]
    node _io_rdata1_T_1 = mux(_io_rdata1_T, _regs_io_raddr1, UInt<1>("h0")) @[registerfile.scala 15:18]
    node _io_rdata2_T = orr(io_raddr2) @[registerfile.scala 16:35]
    node _GEN_32 = validif(eq(UInt<1>("h0"), io_raddr2), regs_0) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_33 = mux(eq(UInt<1>("h1"), io_raddr2), regs_1, _GEN_32) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_34 = mux(eq(UInt<2>("h2"), io_raddr2), regs_2, _GEN_33) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_35 = mux(eq(UInt<2>("h3"), io_raddr2), regs_3, _GEN_34) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_36 = mux(eq(UInt<3>("h4"), io_raddr2), regs_4, _GEN_35) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_37 = mux(eq(UInt<3>("h5"), io_raddr2), regs_5, _GEN_36) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_38 = mux(eq(UInt<3>("h6"), io_raddr2), regs_6, _GEN_37) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_39 = mux(eq(UInt<3>("h7"), io_raddr2), regs_7, _GEN_38) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_40 = mux(eq(UInt<4>("h8"), io_raddr2), regs_8, _GEN_39) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_41 = mux(eq(UInt<4>("h9"), io_raddr2), regs_9, _GEN_40) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_42 = mux(eq(UInt<4>("ha"), io_raddr2), regs_10, _GEN_41) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_43 = mux(eq(UInt<4>("hb"), io_raddr2), regs_11, _GEN_42) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_44 = mux(eq(UInt<4>("hc"), io_raddr2), regs_12, _GEN_43) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_45 = mux(eq(UInt<4>("hd"), io_raddr2), regs_13, _GEN_44) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_46 = mux(eq(UInt<4>("he"), io_raddr2), regs_14, _GEN_45) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_47 = mux(eq(UInt<4>("hf"), io_raddr2), regs_15, _GEN_46) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_48 = mux(eq(UInt<5>("h10"), io_raddr2), regs_16, _GEN_47) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_49 = mux(eq(UInt<5>("h11"), io_raddr2), regs_17, _GEN_48) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_50 = mux(eq(UInt<5>("h12"), io_raddr2), regs_18, _GEN_49) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_51 = mux(eq(UInt<5>("h13"), io_raddr2), regs_19, _GEN_50) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_52 = mux(eq(UInt<5>("h14"), io_raddr2), regs_20, _GEN_51) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_53 = mux(eq(UInt<5>("h15"), io_raddr2), regs_21, _GEN_52) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_54 = mux(eq(UInt<5>("h16"), io_raddr2), regs_22, _GEN_53) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_55 = mux(eq(UInt<5>("h17"), io_raddr2), regs_23, _GEN_54) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_56 = mux(eq(UInt<5>("h18"), io_raddr2), regs_24, _GEN_55) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_57 = mux(eq(UInt<5>("h19"), io_raddr2), regs_25, _GEN_56) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_58 = mux(eq(UInt<5>("h1a"), io_raddr2), regs_26, _GEN_57) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_59 = mux(eq(UInt<5>("h1b"), io_raddr2), regs_27, _GEN_58) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_60 = mux(eq(UInt<5>("h1c"), io_raddr2), regs_28, _GEN_59) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_61 = mux(eq(UInt<5>("h1d"), io_raddr2), regs_29, _GEN_60) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_62 = mux(eq(UInt<5>("h1e"), io_raddr2), regs_30, _GEN_61) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _GEN_63 = mux(eq(UInt<5>("h1f"), io_raddr2), regs_31, _GEN_62) @[registerfile.scala 16:18 registerfile.scala 16:18]
    node _regs_io_raddr2 = _GEN_63 @[registerfile.scala 16:18]
    node _io_rdata2_T_1 = mux(_io_rdata2_T, _regs_io_raddr2, UInt<1>("h0")) @[registerfile.scala 16:18]
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
    io_rdata1 <= _io_rdata1_T_1 @[registerfile.scala 15:11]
    io_rdata2 <= _io_rdata2_T_1 @[registerfile.scala 16:11]
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
    input io_decode_instruction : UInt<32>
    output io_decode_func3_7 : UInt<3>
    output io_decode_imm_out : UInt<32>
    output io_decode_regf_rdata1 : UInt<32>
    output io_decode_regf_rdata2 : UInt<32>
    input io_decode_regf_wdata : UInt<32>

    inst cumod of controlunit @[decode.scala 28:23]
    inst immgmod of immgenr @[decode.scala 29:25]
    inst regfmod of registerfile @[decode.scala 30:25]
    io_decode_func3_7 <= cumod.io_func3_7 @[decode.scala 38:23]
    io_decode_imm_out <= immgmod.io_imm @[decode.scala 43:23]
    io_decode_regf_rdata1 <= regfmod.io_rdata1 @[decode.scala 54:27]
    io_decode_regf_rdata2 <= regfmod.io_rdata2 @[decode.scala 55:27]
    cumod.clock <= clock
    cumod.reset <= reset
    cumod.io_instruction <= io_decode_instruction @[decode.scala 34:26]
    immgmod.clock <= clock
    immgmod.reset <= reset
    immgmod.io_instruction <= io_decode_instruction @[decode.scala 42:27]
    regfmod.clock <= clock
    regfmod.reset <= reset
    regfmod.io_raddr1 <= cumod.io_rs1 @[decode.scala 47:23]
    regfmod.io_raddr2 <= cumod.io_rs2 @[decode.scala 48:23]
    regfmod.io_wen <= cumod.io_en_reg @[decode.scala 49:20]
    regfmod.io_waddr <= cumod.io_rd @[decode.scala 50:22]
    regfmod.io_wdata <= io_decode_regf_wdata @[decode.scala 56:22]

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
    output io_jump_execute : UInt<1>
    input io_pc_fetch : UInt<32>
    output io_pc_imm_added : UInt<32>

    inst alumod of alu @[execute.scala 32:24]
    node _T = bits(io_ins_execute, 6, 0) @[execute.scala 42:25]
    node _T_1 = eq(_T, UInt<6>("h33")) @[execute.scala 42:31]
    node _T_2 = bits(io_ins_execute, 6, 0) @[execute.scala 45:30]
    node _T_3 = eq(_T_2, UInt<5>("h13")) @[execute.scala 45:36]
    node _GEN_0 = mux(_T_3, io_imm_execute, UInt<1>("h0")) @[execute.scala 45:48 execute.scala 46:17 execute.scala 33:17]
    node _GEN_1 = mux(_T_1, io_B_alu_execute, _GEN_0) @[execute.scala 42:44 execute.scala 43:17]
    node _T_4 = bits(io_ins_execute, 6, 0) @[execute.scala 51:21]
    node _T_5 = eq(_T_4, UInt<7>("h63")) @[execute.scala 51:27]
    node _T_6 = bits(io_ins_execute, 14, 12) @[execute.scala 60:24]
    node _T_7 = eq(_T_6, UInt<1>("h0")) @[execute.scala 60:33]
    node _T_8 = eq(io_A_alu_execute, io_B_alu_execute) @[execute.scala 61:29]
    node _GEN_2 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[execute.scala 61:51 execute.scala 62:25 execute.scala 28:21]
    node _T_9 = bits(io_ins_execute, 14, 12) @[execute.scala 64:30]
    node _T_10 = eq(_T_9, UInt<1>("h1")) @[execute.scala 64:39]
    node _T_11 = neq(io_A_alu_execute, io_B_alu_execute) @[execute.scala 65:29]
    node _GEN_3 = mux(_T_11, UInt<1>("h1"), UInt<1>("h0")) @[execute.scala 65:51 execute.scala 66:25 execute.scala 28:21]
    node _T_12 = bits(io_ins_execute, 14, 12) @[execute.scala 68:30]
    node _T_13 = eq(_T_12, UInt<2>("h2")) @[execute.scala 68:39]
    node _T_14 = lt(io_A_alu_execute, io_B_alu_execute) @[execute.scala 69:29]
    node _GEN_4 = mux(_T_14, UInt<1>("h1"), UInt<1>("h0")) @[execute.scala 69:49 execute.scala 70:25 execute.scala 28:21]
    node _T_15 = bits(io_ins_execute, 14, 12) @[execute.scala 72:30]
    node _T_16 = eq(_T_15, UInt<2>("h3")) @[execute.scala 72:39]
    node _T_17 = geq(io_A_alu_execute, io_B_alu_execute) @[execute.scala 73:29]
    node _GEN_5 = mux(_T_17, UInt<1>("h1"), UInt<1>("h0")) @[execute.scala 73:50 execute.scala 74:25 execute.scala 28:21]
    node _T_18 = bits(io_ins_execute, 14, 12) @[execute.scala 76:30]
    node _T_19 = eq(_T_18, UInt<3>("h4")) @[execute.scala 76:39]
    node _T_20 = lt(io_A_alu_execute, io_B_alu_execute) @[execute.scala 77:36]
    node _GEN_6 = mux(_T_20, UInt<1>("h1"), UInt<1>("h0")) @[execute.scala 77:65 execute.scala 78:25 execute.scala 28:21]
    node _T_21 = bits(io_ins_execute, 14, 12) @[execute.scala 80:30]
    node _T_22 = eq(_T_21, UInt<3>("h5")) @[execute.scala 80:39]
    node _T_23 = geq(io_A_alu_execute, io_B_alu_execute) @[execute.scala 81:36]
    node _GEN_7 = mux(_T_23, UInt<1>("h1"), UInt<1>("h0")) @[execute.scala 81:66 execute.scala 82:25 execute.scala 28:21]
    node _GEN_8 = mux(_T_22, _GEN_7, UInt<1>("h0")) @[execute.scala 80:48 execute.scala 28:21]
    node _GEN_9 = mux(_T_19, _GEN_6, _GEN_8) @[execute.scala 76:48]
    node _GEN_10 = mux(_T_16, _GEN_5, _GEN_9) @[execute.scala 72:48]
    node _GEN_11 = mux(_T_13, _GEN_4, _GEN_10) @[execute.scala 68:48]
    node _GEN_12 = mux(_T_10, _GEN_3, _GEN_11) @[execute.scala 64:48]
    node _GEN_13 = mux(_T_7, _GEN_2, _GEN_12) @[execute.scala 60:42]
    node _GEN_14 = mux(_T_5, io_imm_execute, _GEN_1) @[execute.scala 51:37 execute.scala 54:15]
    node _GEN_15 = mux(_T_5, _GEN_13, UInt<1>("h0")) @[execute.scala 51:37 execute.scala 28:21]
    node _io_pc_imm_added_T = add(io_imm_execute, io_pc_fetch) @[execute.scala 169:41]
    node _io_pc_imm_added_T_1 = tail(_io_pc_imm_added_T, 1) @[execute.scala 169:41]
    io_out_alu_execute <= alumod.io_out @[execute.scala 39:24]
    io_jump_execute <= _GEN_15
    io_pc_imm_added <= _io_pc_imm_added_T_1 @[execute.scala 169:22]
    alumod.clock <= clock
    alumod.reset <= reset
    alumod.io_A <= io_A_alu_execute @[execute.scala 37:17]
    alumod.io_B <= _GEN_14
    alumod.io_op <= io_op_alu_execute @[execute.scala 38:18]

  module datamemory :
    input clock : Clock
    input reset : UInt<1>
    output io_out : UInt<32>
    input io_datain : UInt<32>
    input io_addr : UInt<8>
    input io_rd_enable : UInt<1>
    input io_wr_enable : UInt<1>

    mem memory : @[datamemory.scala 19:19]
      data-type => UInt<8>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => io_out_MPORT
      writer => MPORT
      read-under-write => undefined
    node _GEN_0 = validif(io_wr_enable, io_addr) @[datamemory.scala 22:22]
    node _GEN_1 = validif(io_wr_enable, clock) @[datamemory.scala 22:22]
    node _GEN_2 = mux(io_wr_enable, UInt<1>("h1"), UInt<1>("h0")) @[datamemory.scala 22:22 datamemory.scala 19:19]
    node _GEN_3 = validif(io_wr_enable, UInt<1>("h1")) @[datamemory.scala 22:22]
    node _GEN_4 = validif(io_wr_enable, io_datain) @[datamemory.scala 22:22]
    node _GEN_5 = validif(io_rd_enable, io_addr) @[datamemory.scala 25:22 datamemory.scala 26:26]
    node _GEN_6 = validif(io_rd_enable, clock) @[datamemory.scala 25:22 datamemory.scala 26:26]
    node _GEN_7 = mux(io_rd_enable, UInt<1>("h1"), UInt<1>("h0")) @[datamemory.scala 25:22 datamemory.scala 26:26 datamemory.scala 19:19]
    node _GEN_8 = mux(io_rd_enable, memory.io_out_MPORT.data, UInt<1>("h0")) @[datamemory.scala 25:22 datamemory.scala 26:12 datamemory.scala 14:9]
    io_out <= _GEN_8
    memory.io_out_MPORT.addr <= _GEN_5
    memory.io_out_MPORT.en <= _GEN_7
    memory.io_out_MPORT.clk <= _GEN_6
    memory.MPORT.addr <= _GEN_0
    memory.MPORT.en <= _GEN_2
    memory.MPORT.clk <= _GEN_1
    memory.MPORT.data <= bits(_GEN_4, 7, 0)
    memory.MPORT.mask <= _GEN_3

  module mem :
    input clock : Clock
    input reset : UInt<1>
    output io_out_mem : UInt<32>
    input io_datain_mem : UInt<32>
    input io_addr_mem : UInt<8>
    input io_rd_enable_mem : UInt<1>
    input io_wr_enable_mem : UInt<1>

    inst datamemorymod of datamemory @[mem.scala 18:31]
    io_out_mem <= datamemorymod.io_out @[mem.scala 26:16]
    datamemorymod.clock <= clock
    datamemorymod.reset <= reset
    datamemorymod.io_datain <= io_datain_mem @[mem.scala 22:29]
    datamemorymod.io_addr <= io_addr_mem @[mem.scala 23:27]
    datamemorymod.io_rd_enable <= io_rd_enable_mem @[mem.scala 24:32]
    datamemorymod.io_wr_enable <= io_wr_enable_mem @[mem.scala 25:32]

  module wb :
    input clock : Clock
    input reset : UInt<1>
    output io_wb_dataout : UInt<32>
    input io_wb_datamem_in : UInt<32>
    input io_wb_alu_out : UInt<32>
    input io_ins : UInt<32>

    node _io_wb_dataout_T = bits(io_ins, 6, 0) @[wb.scala 16:29]
    node _io_wb_dataout_T_1 = eq(_io_wb_dataout_T, UInt<2>("h3")) @[wb.scala 16:34]
    node _io_wb_dataout_T_2 = mux(_io_wb_dataout_T_1, io_wb_datamem_in, io_wb_alu_out) @[wb.scala 16:22]
    io_wb_dataout <= _io_wb_dataout_T_2 @[wb.scala 16:16]

  module topcore :
    input clock : Clock
    input reset : UInt<1>
    output io_out : UInt<32>

    inst fetch_module of fetch @[topcore.scala 15:28]
    inst decode_module of decode @[topcore.scala 16:29]
    inst execute_module of execute @[topcore.scala 17:30]
    inst mem_module of mem @[topcore.scala 18:26]
    inst wb_module of wb @[topcore.scala 19:25]
    io_out <= wb_module.io_wb_dataout @[topcore.scala 65:12]
    fetch_module.clock <= clock
    fetch_module.reset <= reset
    fetch_module.io_pc_imm_execute <= execute_module.io_pc_imm_added @[topcore.scala 27:36]
    fetch_module.io_jump_fetch <= execute_module.io_jump_execute @[topcore.scala 69:32]
    decode_module.clock <= clock
    decode_module.reset <= reset
    decode_module.io_decode_instruction <= fetch_module.io_Imem_fetch_out @[topcore.scala 24:41]
    decode_module.io_decode_regf_wdata <= wb_module.io_wb_dataout @[topcore.scala 54:41]
    execute_module.clock <= clock
    execute_module.reset <= reset
    execute_module.io_A_alu_execute <= decode_module.io_decode_regf_rdata1 @[topcore.scala 34:37]
    execute_module.io_B_alu_execute <= decode_module.io_decode_regf_rdata2 @[topcore.scala 35:37]
    execute_module.io_op_alu_execute <= decode_module.io_decode_func3_7 @[topcore.scala 37:38]
    execute_module.io_ins_execute <= decode_module.io_decode_instruction @[topcore.scala 36:35]
    execute_module.io_imm_execute <= decode_module.io_decode_imm_out @[topcore.scala 42:35]
    execute_module.io_pc_fetch <= fetch_module.io_pc_fetch_out @[topcore.scala 25:32]
    mem_module.clock <= clock
    mem_module.reset <= reset
    mem_module.io_datain_mem <= execute_module.io_out_alu_execute @[topcore.scala 47:30]
    mem_module.io_addr_mem <= UInt<1>("h0") @[topcore.scala 58:28]
    mem_module.io_rd_enable_mem <= UInt<1>("h0") @[topcore.scala 57:33]
    mem_module.io_wr_enable_mem <= UInt<1>("h0") @[topcore.scala 56:33]
    wb_module.clock <= clock
    wb_module.reset <= reset
    wb_module.io_wb_datamem_in <= mem_module.io_out_mem @[topcore.scala 50:32]
    wb_module.io_wb_alu_out <= execute_module.io_out_alu_execute @[topcore.scala 51:29]
    wb_module.io_ins <= fetch_module.io_Imem_fetch_out @[topcore.scala 60:22]
