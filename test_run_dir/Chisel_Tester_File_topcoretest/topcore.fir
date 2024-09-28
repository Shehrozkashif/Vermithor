;buildInfoPackage: chisel3, version: 3.4.3, scalaVersion: 2.12.12, sbtVersion: 1.3.10
circuit topcore : 
  module pc : 
    input clock : Clock
    input reset : Reset
    output io : {flip imm : UInt<32>, out : UInt<32>, flip jump : UInt<1>}
    
    io.out <= UInt<1>("h00") @[pc.scala 19:10]
    reg pc : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[pc.scala 21:19]
    when io.jump : @[pc.scala 23:14]
      pc <= io.imm @[pc.scala 24:4]
      skip @[pc.scala 23:14]
    else : @[pc.scala 26:11]
      node _pc_T = add(pc, UInt<3>("h04")) @[pc.scala 27:11]
      node _pc_T_1 = tail(_pc_T, 1) @[pc.scala 27:11]
      pc <= _pc_T_1 @[pc.scala 27:4]
      skip @[pc.scala 26:11]
    io.out <= pc @[pc.scala 30:8]
    
  module Imem : 
    input clock : Clock
    input reset : Reset
    output io : {flip address : UInt<32>, out : UInt<32>}
    
    cmem memory : UInt<32>[1024] @[Imem.scala 11:17]
    node _T = shr(io.address, 2) @[Imem.scala 17:26]
    node _T_1 = bits(_T, 9, 0)
    write mport MPORT = memory[_T_1], clock
    MPORT <= UInt<1>("h00")
    node _io_out_T = shr(io.address, 2) @[Imem.scala 19:35]
    node _io_out_T_1 = bits(_io_out_T, 9, 0) @[Imem.scala 19:22]
    read mport io_out_MPORT = memory[_io_out_T_1], clock @[Imem.scala 19:22]
    io.out <= io_out_MPORT @[Imem.scala 19:8]
    
  module fetch : 
    input clock : Clock
    input reset : Reset
    output io : {pc_fetch_out : UInt<32>, Imem_fetch_out : UInt<32>, flip pc_imm_execute : UInt<32>}
    
    inst pcmod of pc @[fetch.scala 25:23]
    pcmod.clock <= clock
    pcmod.reset <= reset
    inst inmmod of Imem @[fetch.scala 26:24]
    inmmod.clock <= clock
    inmmod.reset <= reset
    inmmod.io.address <= pcmod.io.out @[fetch.scala 35:23]
    pcmod.io.imm <= io.pc_imm_execute @[fetch.scala 39:18]
    io.pc_fetch_out <= pcmod.io.out @[fetch.scala 44:21]
    io.Imem_fetch_out <= inmmod.io.out @[fetch.scala 48:23]
    node _T = bits(io.Imem_fetch_out, 6, 0) @[fetch.scala 50:27]
    node _T_1 = eq(_T, UInt<7>("h063")) @[fetch.scala 50:34]
    node _T_2 = bits(io.Imem_fetch_out, 6, 0) @[fetch.scala 50:63]
    node _T_3 = eq(_T_2, UInt<7>("h06f")) @[fetch.scala 50:69]
    node _T_4 = or(_T_1, _T_3) @[fetch.scala 50:43]
    when _T_4 : @[fetch.scala 50:82]
      pcmod.io.jump <= UInt<1>("h01") @[fetch.scala 51:23]
      skip @[fetch.scala 50:82]
    else : @[fetch.scala 53:15]
      pcmod.io.jump <= UInt<1>("h00") @[fetch.scala 54:21]
      skip @[fetch.scala 53:15]
    
  module controlunit : 
    input clock : Clock
    input reset : Reset
    output io : {flip instruction : UInt<32>, func3_7 : UInt<3>, en_reg : UInt<1>, rd : UInt<5>, rs2 : UInt<5>, rs1 : UInt<5>, imm : UInt<12>}
    
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
    
  module immgenr : 
    input clock : Clock
    input reset : Reset
    output io : {flip instruction : UInt<32>, imm : UInt<32>}
    
    io.imm <= UInt<1>("h00") @[immgenr.scala 23:10]
    node opcode = bits(io.instruction, 6, 0) @[immgenr.scala 24:30]
    node _T = eq(UInt<5>("h013"), opcode) @[Conditional.scala 37:30]
    when _T : @[Conditional.scala 40:58]
      node _io_imm_T = bits(io.instruction, 31, 31) @[immgenr.scala 27:44]
      node _io_imm_T_1 = bits(_io_imm_T, 0, 0) @[Bitwise.scala 72:15]
      node io_imm_hi = mux(_io_imm_T_1, UInt<20>("h0fffff"), UInt<20>("h00")) @[Bitwise.scala 72:12]
      node io_imm_lo = bits(io.instruction, 31, 20) @[immgenr.scala 27:65]
      node _io_imm_T_2 = cat(io_imm_hi, io_imm_lo) @[Cat.scala 30:58]
      io.imm <= _io_imm_T_2 @[immgenr.scala 27:14]
      skip @[Conditional.scala 40:58]
    else : @[Conditional.scala 39:67]
      node _T_1 = eq(UInt<2>("h03"), opcode) @[Conditional.scala 37:30]
      when _T_1 : @[Conditional.scala 39:67]
        node _io_imm_T_3 = bits(io.instruction, 31, 31) @[immgenr.scala 30:44]
        node _io_imm_T_4 = bits(_io_imm_T_3, 0, 0) @[Bitwise.scala 72:15]
        node io_imm_hi_1 = mux(_io_imm_T_4, UInt<20>("h0fffff"), UInt<20>("h00")) @[Bitwise.scala 72:12]
        node io_imm_lo_1 = bits(io.instruction, 31, 20) @[immgenr.scala 30:65]
        node _io_imm_T_5 = cat(io_imm_hi_1, io_imm_lo_1) @[Cat.scala 30:58]
        io.imm <= _io_imm_T_5 @[immgenr.scala 30:14]
        skip @[Conditional.scala 39:67]
      else : @[Conditional.scala 39:67]
        node _T_2 = eq(UInt<6>("h023"), opcode) @[Conditional.scala 37:30]
        when _T_2 : @[Conditional.scala 39:67]
          node _io_imm_T_6 = bits(io.instruction, 31, 31) @[immgenr.scala 33:44]
          node _io_imm_T_7 = bits(_io_imm_T_6, 0, 0) @[Bitwise.scala 72:15]
          node io_imm_hi_hi = mux(_io_imm_T_7, UInt<20>("h0fffff"), UInt<20>("h00")) @[Bitwise.scala 72:12]
          node io_imm_hi_lo = bits(io.instruction, 31, 25) @[immgenr.scala 33:65]
          node io_imm_lo_2 = bits(io.instruction, 11, 7) @[immgenr.scala 33:89]
          node io_imm_hi_2 = cat(io_imm_hi_hi, io_imm_hi_lo) @[Cat.scala 30:58]
          node _io_imm_T_8 = cat(io_imm_hi_2, io_imm_lo_2) @[Cat.scala 30:58]
          io.imm <= _io_imm_T_8 @[immgenr.scala 33:14]
          skip @[Conditional.scala 39:67]
        else : @[Conditional.scala 39:67]
          node _T_3 = eq(UInt<7>("h063"), opcode) @[Conditional.scala 37:30]
          when _T_3 : @[Conditional.scala 39:67]
            node _io_imm_T_9 = bits(io.instruction, 31, 31) @[immgenr.scala 36:44]
            node _io_imm_T_10 = bits(_io_imm_T_9, 0, 0) @[Bitwise.scala 72:15]
            node io_imm_hi_hi_hi = mux(_io_imm_T_10, UInt<19>("h07ffff"), UInt<19>("h00")) @[Bitwise.scala 72:12]
            node io_imm_hi_hi_lo = bits(io.instruction, 31, 31) @[immgenr.scala 36:65]
            node io_imm_hi_lo_1 = bits(io.instruction, 7, 7) @[immgenr.scala 36:85]
            node io_imm_lo_hi_hi = bits(io.instruction, 30, 25) @[immgenr.scala 36:104]
            node io_imm_lo_hi_lo = bits(io.instruction, 11, 8) @[immgenr.scala 36:127]
            node io_imm_lo_hi = cat(io_imm_lo_hi_hi, io_imm_lo_hi_lo) @[Cat.scala 30:58]
            node io_imm_lo_3 = cat(io_imm_lo_hi, UInt<1>("h00")) @[Cat.scala 30:58]
            node io_imm_hi_hi_1 = cat(io_imm_hi_hi_hi, io_imm_hi_hi_lo) @[Cat.scala 30:58]
            node io_imm_hi_3 = cat(io_imm_hi_hi_1, io_imm_hi_lo_1) @[Cat.scala 30:58]
            node _io_imm_T_11 = cat(io_imm_hi_3, io_imm_lo_3) @[Cat.scala 30:58]
            io.imm <= _io_imm_T_11 @[immgenr.scala 36:14]
            skip @[Conditional.scala 39:67]
          else : @[Conditional.scala 39:67]
            node _T_4 = eq(UInt<6>("h037"), opcode) @[Conditional.scala 37:30]
            when _T_4 : @[Conditional.scala 39:67]
              node io_imm_hi_4 = bits(io.instruction, 31, 12) @[immgenr.scala 40:35]
              node io_imm_lo_4 = mux(UInt<1>("h00"), UInt<12>("h0fff"), UInt<12>("h00")) @[Bitwise.scala 72:12]
              node _io_imm_T_12 = cat(io_imm_hi_4, io_imm_lo_4) @[Cat.scala 30:58]
              io.imm <= _io_imm_T_12 @[immgenr.scala 40:14]
              skip @[Conditional.scala 39:67]
            else : @[Conditional.scala 39:67]
              node _T_5 = eq(UInt<32>("h017"), opcode) @[Conditional.scala 37:30]
              when _T_5 : @[Conditional.scala 39:67]
                node io_imm_hi_5 = bits(io.instruction, 31, 12) @[immgenr.scala 43:35]
                node io_imm_lo_5 = mux(UInt<1>("h00"), UInt<12>("h0fff"), UInt<12>("h00")) @[Bitwise.scala 72:12]
                node _io_imm_T_13 = cat(io_imm_hi_5, io_imm_lo_5) @[Cat.scala 30:58]
                io.imm <= _io_imm_T_13 @[immgenr.scala 43:14]
                skip @[Conditional.scala 39:67]
              else : @[Conditional.scala 39:67]
                node _T_6 = eq(UInt<32>("h06f"), opcode) @[Conditional.scala 37:30]
                when _T_6 : @[Conditional.scala 39:67]
                  node _io_imm_T_14 = bits(io.instruction, 31, 31) @[immgenr.scala 49:44]
                  node _io_imm_T_15 = bits(_io_imm_T_14, 0, 0) @[Bitwise.scala 72:15]
                  node io_imm_hi_hi_hi_1 = mux(_io_imm_T_15, UInt<11>("h07ff"), UInt<11>("h00")) @[Bitwise.scala 72:12]
                  node io_imm_hi_hi_lo_1 = bits(io.instruction, 31, 31) @[immgenr.scala 49:65]
                  node io_imm_hi_lo_2 = bits(io.instruction, 19, 12) @[immgenr.scala 49:85]
                  node io_imm_lo_hi_hi_1 = bits(io.instruction, 20, 20) @[immgenr.scala 49:109]
                  node io_imm_lo_hi_lo_1 = bits(io.instruction, 30, 21) @[immgenr.scala 49:129]
                  node io_imm_lo_hi_1 = cat(io_imm_lo_hi_hi_1, io_imm_lo_hi_lo_1) @[Cat.scala 30:58]
                  node io_imm_lo_6 = cat(io_imm_lo_hi_1, UInt<1>("h00")) @[Cat.scala 30:58]
                  node io_imm_hi_hi_2 = cat(io_imm_hi_hi_hi_1, io_imm_hi_hi_lo_1) @[Cat.scala 30:58]
                  node io_imm_hi_6 = cat(io_imm_hi_hi_2, io_imm_hi_lo_2) @[Cat.scala 30:58]
                  node _io_imm_T_16 = cat(io_imm_hi_6, io_imm_lo_6) @[Cat.scala 30:58]
                  io.imm <= _io_imm_T_16 @[immgenr.scala 49:14]
                  skip @[Conditional.scala 39:67]
                else : @[Conditional.scala 39:67]
                  node _T_7 = eq(UInt<32>("h067"), opcode) @[Conditional.scala 37:30]
                  when _T_7 : @[Conditional.scala 39:67]
                    node _io_imm_T_17 = bits(io.instruction, 31, 31) @[immgenr.scala 53:44]
                    node _io_imm_T_18 = bits(_io_imm_T_17, 0, 0) @[Bitwise.scala 72:15]
                    node io_imm_hi_7 = mux(_io_imm_T_18, UInt<20>("h0fffff"), UInt<20>("h00")) @[Bitwise.scala 72:12]
                    node io_imm_lo_7 = bits(io.instruction, 31, 20) @[immgenr.scala 53:65]
                    node _io_imm_T_19 = cat(io_imm_hi_7, io_imm_lo_7) @[Cat.scala 30:58]
                    io.imm <= _io_imm_T_19 @[immgenr.scala 53:14]
                    skip @[Conditional.scala 39:67]
    
  module registerfile : 
    input clock : Clock
    input reset : Reset
    output io : {flip raddr1 : UInt<5>, flip raddr2 : UInt<5>, rdata1 : UInt<32>, rdata2 : UInt<32>, flip wen : UInt<1>, flip waddr : UInt<5>, flip wdata : UInt<32>}
    
    reg regs : UInt<32>[32], clock @[registerfile.scala 14:16]
    node _io_rdata1_T = orr(io.raddr1) @[registerfile.scala 15:35]
    node _io_rdata1_T_1 = mux(_io_rdata1_T, regs[io.raddr1], UInt<1>("h00")) @[registerfile.scala 15:18]
    io.rdata1 <= _io_rdata1_T_1 @[registerfile.scala 15:11]
    node _io_rdata2_T = orr(io.raddr2) @[registerfile.scala 16:35]
    node _io_rdata2_T_1 = mux(_io_rdata2_T, regs[io.raddr2], UInt<1>("h00")) @[registerfile.scala 16:18]
    io.rdata2 <= _io_rdata2_T_1 @[registerfile.scala 16:11]
    node _T = orr(io.waddr) @[registerfile.scala 17:32]
    node _T_1 = and(io.wen, _T) @[registerfile.scala 17:17]
    when _T_1 : @[registerfile.scala 17:38]
      regs[io.waddr] <= io.wdata @[registerfile.scala 18:25]
      skip @[registerfile.scala 17:38]
    
  module decode : 
    input clock : Clock
    input reset : Reset
    output io : {flip decode_instruction : UInt<32>, decode_func3_7 : UInt<3>, decode_imm_out : UInt<32>, decode_regf_rdata1 : UInt<32>, decode_regf_rdata2 : UInt<32>, flip decode_regf_wdata : UInt<32>}
    
    inst cumod of controlunit @[decode.scala 28:23]
    cumod.clock <= clock
    cumod.reset <= reset
    inst immgmod of immgenr @[decode.scala 29:25]
    immgmod.clock <= clock
    immgmod.reset <= reset
    inst regfmod of registerfile @[decode.scala 30:25]
    regfmod.clock <= clock
    regfmod.reset <= reset
    cumod.io.instruction <= io.decode_instruction @[decode.scala 34:26]
    io.decode_func3_7 <= cumod.io.func3_7 @[decode.scala 38:23]
    immgmod.io.instruction <= io.decode_instruction @[decode.scala 42:27]
    io.decode_imm_out <= immgmod.io.imm @[decode.scala 43:23]
    regfmod.io.raddr1 <= cumod.io.rs1 @[decode.scala 47:23]
    regfmod.io.raddr2 <= cumod.io.rs2 @[decode.scala 48:23]
    regfmod.io.wen <= cumod.io.en_reg @[decode.scala 49:20]
    regfmod.io.waddr <= cumod.io.rd @[decode.scala 50:22]
    io.decode_regf_rdata1 <= regfmod.io.rdata1 @[decode.scala 54:27]
    io.decode_regf_rdata2 <= regfmod.io.rdata2 @[decode.scala 55:27]
    regfmod.io.wdata <= io.decode_regf_wdata @[decode.scala 56:22]
    
  module alu : 
    input clock : Clock
    input reset : Reset
    output io : {flip A : UInt<32>, flip B : UInt<32>, flip op : UInt<4>, out : UInt<32>}
    
    io.out <= UInt<1>("h00") @[alu.scala 27:9]
    node shiftamount = bits(io.B, 4, 0) @[alu.scala 28:25]
    io.out <= UInt<1>("h00") @[alu.scala 29:10]
    node _T = eq(UInt<4>("h00"), io.op) @[Conditional.scala 37:30]
    when _T : @[Conditional.scala 40:58]
      node _io_out_T = add(io.A, io.B) @[alu.scala 32:22]
      node _io_out_T_1 = tail(_io_out_T, 1) @[alu.scala 32:22]
      io.out <= _io_out_T_1 @[alu.scala 32:14]
      skip @[Conditional.scala 40:58]
    else : @[Conditional.scala 39:67]
      node _T_1 = eq(UInt<4>("h08"), io.op) @[Conditional.scala 37:30]
      when _T_1 : @[Conditional.scala 39:67]
        node _io_out_T_2 = sub(io.A, io.B) @[alu.scala 35:22]
        node _io_out_T_3 = tail(_io_out_T_2, 1) @[alu.scala 35:22]
        io.out <= _io_out_T_3 @[alu.scala 35:14]
        skip @[Conditional.scala 39:67]
      else : @[Conditional.scala 39:67]
        node _T_2 = eq(UInt<4>("h07"), io.op) @[Conditional.scala 37:30]
        when _T_2 : @[Conditional.scala 39:67]
          node _io_out_T_4 = and(io.A, io.B) @[alu.scala 38:22]
          io.out <= _io_out_T_4 @[alu.scala 38:14]
          skip @[Conditional.scala 39:67]
        else : @[Conditional.scala 39:67]
          node _T_3 = eq(UInt<4>("h06"), io.op) @[Conditional.scala 37:30]
          when _T_3 : @[Conditional.scala 39:67]
            node _io_out_T_5 = or(io.A, io.B) @[alu.scala 41:22]
            io.out <= _io_out_T_5 @[alu.scala 41:14]
            skip @[Conditional.scala 39:67]
          else : @[Conditional.scala 39:67]
            node _T_4 = eq(UInt<4>("h04"), io.op) @[Conditional.scala 37:30]
            when _T_4 : @[Conditional.scala 39:67]
              node _io_out_T_6 = xor(io.A, io.B) @[alu.scala 44:22]
              io.out <= _io_out_T_6 @[alu.scala 44:14]
              skip @[Conditional.scala 39:67]
            else : @[Conditional.scala 39:67]
              node _T_5 = eq(UInt<4>("h02"), io.op) @[Conditional.scala 37:30]
              when _T_5 : @[Conditional.scala 39:67]
                node _T_6 = lt(io.A, io.B) @[alu.scala 47:18]
                when _T_6 : @[alu.scala 47:26]
                  io.out <= UInt<1>("h01") @[alu.scala 48:16]
                  skip @[alu.scala 47:26]
                skip @[Conditional.scala 39:67]
              else : @[Conditional.scala 39:67]
                node _T_7 = eq(UInt<4>("h01"), io.op) @[Conditional.scala 37:30]
                when _T_7 : @[Conditional.scala 39:67]
                  node _io_out_T_7 = dshl(io.A, shiftamount) @[alu.scala 52:22]
                  io.out <= _io_out_T_7 @[alu.scala 52:14]
                  skip @[Conditional.scala 39:67]
                else : @[Conditional.scala 39:67]
                  node _T_8 = eq(UInt<4>("h03"), io.op) @[Conditional.scala 37:30]
                  when _T_8 : @[Conditional.scala 39:67]
                    node _T_9 = lt(io.A, io.B) @[alu.scala 58:18]
                    when _T_9 : @[alu.scala 58:25]
                      io.out <= UInt<1>("h01") @[alu.scala 59:16]
                      skip @[alu.scala 58:25]
                    skip @[Conditional.scala 39:67]
                  else : @[Conditional.scala 39:67]
                    node _T_10 = eq(UInt<4>("h05"), io.op) @[Conditional.scala 37:30]
                    when _T_10 : @[Conditional.scala 39:67]
                      node _io_out_T_8 = dshr(io.A, shiftamount) @[alu.scala 66:22]
                      io.out <= _io_out_T_8 @[alu.scala 66:15]
                      skip @[Conditional.scala 39:67]
                    else : @[Conditional.scala 39:67]
                      node _T_11 = eq(UInt<4>("h0d"), io.op) @[Conditional.scala 37:30]
                      when _T_11 : @[Conditional.scala 39:67]
                        node _io_out_T_9 = asSInt(io.A) @[alu.scala 69:17]
                        node _io_out_T_10 = dshr(_io_out_T_9, shiftamount) @[alu.scala 69:23]
                        node _io_out_T_11 = asUInt(_io_out_T_10) @[alu.scala 69:38]
                        io.out <= _io_out_T_11 @[alu.scala 69:9]
                        skip @[Conditional.scala 39:67]
    
  module execute : 
    input clock : Clock
    input reset : Reset
    output io : {flip A_alu_execute : UInt<32>, flip B_alu_execute : UInt<32>, flip op_alu_execute : UInt<4>, out_alu_execute : UInt<32>, flip ins_execute : UInt<32>, flip imm_execute : UInt<32>, flip pc_fetch : UInt<32>, pc_imm_added : UInt<32>}
    
    inst alumod of alu @[execute.scala 26:24]
    alumod.clock <= clock
    alumod.reset <= reset
    alumod.io.B <= UInt<1>("h00") @[execute.scala 27:17]
    alumod.io.A <= io.A_alu_execute @[execute.scala 31:17]
    alumod.io.op <= io.op_alu_execute @[execute.scala 32:18]
    io.out_alu_execute <= alumod.io.out @[execute.scala 33:24]
    node _T = bits(io.ins_execute, 6, 0) @[execute.scala 45:25]
    node _T_1 = eq(_T, UInt<6>("h033")) @[execute.scala 45:31]
    when _T_1 : @[execute.scala 45:44]
      alumod.io.B <= io.B_alu_execute @[execute.scala 46:13]
      skip @[execute.scala 45:44]
    else : @[execute.scala 48:44]
      node _T_2 = bits(io.ins_execute, 6, 0) @[execute.scala 48:26]
      node _T_3 = eq(_T_2, UInt<5>("h013")) @[execute.scala 48:32]
      when _T_3 : @[execute.scala 48:44]
        alumod.io.B <= io.imm_execute @[execute.scala 49:13]
        skip @[execute.scala 48:44]
    node _io_pc_imm_added_T = add(io.imm_execute, io.pc_fetch) @[execute.scala 130:41]
    node _io_pc_imm_added_T_1 = tail(_io_pc_imm_added_T, 1) @[execute.scala 130:41]
    io.pc_imm_added <= _io_pc_imm_added_T_1 @[execute.scala 130:22]
    
  module datamemory : 
    input clock : Clock
    input reset : Reset
    output io : {out : UInt<32>, flip datain : UInt<32>, flip addr : UInt<8>, flip rd_enable : UInt<1>, flip wr_enable : UInt<1>}
    
    io.out <= UInt<1>("h00") @[datamemory.scala 14:9]
    cmem memory : UInt<8>[1024] @[datamemory.scala 19:19]
    when io.wr_enable : @[datamemory.scala 22:22]
      write mport MPORT = memory[io.addr], clock
      MPORT <= io.datain
      skip @[datamemory.scala 22:22]
    when io.rd_enable : @[datamemory.scala 25:22]
      read mport io_out_MPORT = memory[io.addr], clock @[datamemory.scala 26:26]
      io.out <= io_out_MPORT @[datamemory.scala 26:12]
      skip @[datamemory.scala 25:22]
    
  module mem : 
    input clock : Clock
    input reset : Reset
    output io : {out_mem : UInt<32>, flip datain_mem : UInt<32>, flip addr_mem : UInt<8>, flip rd_enable_mem : UInt<1>, flip wr_enable_mem : UInt<1>}
    
    inst datamemorymod of datamemory @[mem.scala 18:31]
    datamemorymod.clock <= clock
    datamemorymod.reset <= reset
    datamemorymod.io.datain <= io.datain_mem @[mem.scala 22:29]
    datamemorymod.io.addr <= io.addr_mem @[mem.scala 23:27]
    datamemorymod.io.rd_enable <= io.rd_enable_mem @[mem.scala 24:32]
    datamemorymod.io.wr_enable <= io.wr_enable_mem @[mem.scala 25:32]
    io.out_mem <= datamemorymod.io.out @[mem.scala 26:16]
    
  module wb : 
    input clock : Clock
    input reset : Reset
    output io : {wb_dataout : UInt<32>, flip wb_datamem_in : UInt<32>, flip wb_alu_out : UInt<32>, flip ins : UInt<32>}
    
    node _io_wb_dataout_T = bits(io.ins, 6, 0) @[wb.scala 16:29]
    node _io_wb_dataout_T_1 = eq(_io_wb_dataout_T, UInt<2>("h03")) @[wb.scala 16:34]
    node _io_wb_dataout_T_2 = mux(_io_wb_dataout_T_1, io.wb_datamem_in, io.wb_alu_out) @[wb.scala 16:22]
    io.wb_dataout <= _io_wb_dataout_T_2 @[wb.scala 16:16]
    
  module topcore : 
    input clock : Clock
    input reset : UInt<1>
    output io : {out : UInt<32>}
    
    inst fetch_module of fetch @[topcore.scala 15:28]
    fetch_module.clock <= clock
    fetch_module.reset <= reset
    inst decode_module of decode @[topcore.scala 16:29]
    decode_module.clock <= clock
    decode_module.reset <= reset
    inst execute_module of execute @[topcore.scala 17:30]
    execute_module.clock <= clock
    execute_module.reset <= reset
    inst mem_module of mem @[topcore.scala 18:26]
    mem_module.clock <= clock
    mem_module.reset <= reset
    inst wb_module of wb @[topcore.scala 19:25]
    wb_module.clock <= clock
    wb_module.reset <= reset
    decode_module.io.decode_instruction <= fetch_module.io.Imem_fetch_out @[topcore.scala 24:41]
    execute_module.io.pc_fetch <= fetch_module.io.pc_fetch_out @[topcore.scala 25:32]
    fetch_module.io.pc_imm_execute <= execute_module.io.pc_imm_added @[topcore.scala 27:36]
    execute_module.io.A_alu_execute <= decode_module.io.decode_regf_rdata1 @[topcore.scala 34:37]
    execute_module.io.B_alu_execute <= decode_module.io.decode_regf_rdata2 @[topcore.scala 35:37]
    execute_module.io.ins_execute <= decode_module.io.decode_instruction @[topcore.scala 36:35]
    execute_module.io.op_alu_execute <= decode_module.io.decode_func3_7 @[topcore.scala 37:38]
    execute_module.io.imm_execute <= decode_module.io.decode_imm_out @[topcore.scala 38:35]
    execute_module.io.imm_execute <= decode_module.io.decode_imm_out @[topcore.scala 42:35]
    mem_module.io.datain_mem <= execute_module.io.out_alu_execute @[topcore.scala 47:30]
    wb_module.io.wb_datamem_in <= mem_module.io.out_mem @[topcore.scala 50:32]
    wb_module.io.wb_alu_out <= execute_module.io.out_alu_execute @[topcore.scala 51:29]
    decode_module.io.decode_regf_wdata <= wb_module.io.wb_dataout @[topcore.scala 54:41]
    mem_module.io.wr_enable_mem <= UInt<1>("h00") @[topcore.scala 56:33]
    mem_module.io.rd_enable_mem <= UInt<1>("h00") @[topcore.scala 57:33]
    mem_module.io.addr_mem <= UInt<1>("h00") @[topcore.scala 58:28]
    wb_module.io.ins <= fetch_module.io.Imem_fetch_out @[topcore.scala 60:22]
    io.out <= wb_module.io.wb_dataout @[topcore.scala 65:12]
    
