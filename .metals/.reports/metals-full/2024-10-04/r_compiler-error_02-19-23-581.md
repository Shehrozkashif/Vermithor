file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/topcore.scala
### file%3A%2F%2F%2Fhome%2Fshehroz%2FDesktop%2FNew%2520Folder%25203%2FVermithor%2Fsrc%2Fmain%2Fscala%2Fcore%2Ftopcore.scala:130: error: `identifier` expected but `}` found
    }.elsewhen(cumod.io.instruction(14,12) === "b001".U ){ // load half
    ^

occurred in the presentation compiler.

presentation compiler configuration:
Scala version: 2.12.19
Classpath:
<HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.19/scala-library-2.12.19.jar [exists ]
Options:



action parameters:
uri: file://<HOME>/Desktop/New%20Folder%203/Vermithor/src/main/scala/core/topcore.scala
text:
```scala
package core
import chisel3._
import chisel3.util._


class topcore extends  Module {
  val io = IO(new Bundle{

     val out = Output(UInt(32.W))

  })

  
  // calling objects
  val fetch_module = Module(new fetch)
  val decode_module = Module(new decode)
  val execute_module = Module(new execute)
  val mem_module = Module(new mem)
  val wb_module = Module(new wb)

  

    // conections fetch and decode
    decode_module.io.decode_instruction := fetch_module.io.Imem_fetch_out
    execute_module.io.pc_fetch := fetch_module.io.pc_fetch_out // sending pc to add with imm
    // reciving imm + pc from execute 
    fetch_module.io.pc_imm_execute := execute_module.io.pc_imm_added
    
   
   


    // decode and execute 
    execute_module.io.A_alu_execute := decode_module.io.decode_regf_rdata1
    execute_module.io.B_alu_execute := decode_module.io.decode_regf_rdata2
    execute_module.io.ins_execute := decode_module.io.decode_instruction
    execute_module.io.op_alu_execute := decode_module.io.decode_func3_7
    execute_module.io.imm_execute := decode_module.io.decode_imm_out

    
    // providing pc and imm to add it in execute
    execute_module.io.imm_execute := decode_module.io.decode_imm_out



    // connections between execute and mem
    mem_module.io.datain_mem := execute_module.io.out_alu_execute

    //  execute and mem and wb conncections
    wb_module.io.wb_datamem_out := mem_module.io.out_mem
    wb_module.io.wb_alu_out := execute_module.io.out_alu_execute

    // write back 
    decode_module.io.decode_regf_wdata  := wb_module.io.wb_dataout

    mem_module.io.wr_enable_mem := false.B // Default to false
    mem_module.io.rd_enable_mem := false.B // Default to false
    mem_module.io.addr_mem := 0.U // Default to 

    wb_module.io.ins := fetch_module.io.Imem_fetch_out



    // write back
    io.out := wb_module.io.wb_dataout


    // jump 
    fetch_module.io.jump_fetch :=  execute_module.io.jump_execute



    when(decode_module.io.decode_instruction(6,0) === "h6f".U){   //jal
     fetch_module.io.jump_fetch := 1.B
    decode_module.io.decode_regf_wdata := fetch_module.io.pc_fetch_out + 4.U

    }
    when(decode_module.io.decode_instruction(6,0) === "h67".U){   //jalr
     fetch_module.io.jump_fetch := 1.B
     decode_module.io.decode_regf_wdata := fetch_module.io.pc_fetch_out
      fetch_module.io.pc_imm_execute := decode_module.io.decode_regf_rdata1 + decode_module.io.decode_imm_out
}

    // uuper immeidate type code
    when(decode_module.io.decode_instruction(6,0) === "h37".U ){ // U type lui
    decode_module.io.decode_regf_wdata := decode_module.io.decode_imm_out
    print(decode_module.io.decode_imm_out)
    }
    when(decode_module.io.decode_instruction(6,0) === "h17".U ){ // U type auipc

    decode_module.io.decode_regf_wdata := decode_module.io.decode_imm_out + fetch_module.io.pc_fetch_out

    }



    // address calculation for store type
when(decode_module.io.decode_instruction(6,0) === "h23".U ){
 
 mem_module.io.wr_enable_mem  := 1.B

  mem_module.io.addr_mem := execute_module.io.out_alu_execute(9,2)

 
  when(decode_module.io.decode_instruction(14,12) === 0.U){  // Store Bytes
    mem_module.io.datain_mem  := decode_module.io.decode_regf_rdata2 (7,0)
    

  }.elsewhen(decode_module.io.decode_instruction(14,12) === 1.U){ // store halfword
        mem_module.io.datain_mem  := decode_module.io.decode_regf_rdata2 (15,0)

  
  }.elsewhen(decode_module.io.decode_instruction(14,12) === 2.U){  // store word 
        mem_module.io.datain_mem  := decode_module.io.decode_regf_rdata2 (31,0)
    
  }
  
}

    // load
    when(decode_module.io.decode_instruction(6,0) === "h3".U ){
  mem_module.io.addr_mem := execute_module.io.out_alu_execute(9,2)
  mem_module.io.rd_enable_mem := 1.B
    when(decode_module.io.decode_instruction(14,12) === "b000".U ){ // load byte


      mem_module.io.ecode_regf_wdata := wb_module.
    

    }.elsewhen(cumod.io.instruction(14,12) === "b001".U ){ // load half
            
       when(masksel=== 0.U){
      regfmod.io.wdata := Cat( Fill(16, dmmod.io.out(1)(7)), dmmod.io.out(1), dmmod.io.out(0) )
    }.elsewhen(masksel === 1.U){
      regfmod.io.wdata := Cat( Fill(16, dmmod.io.out(2)(7)), dmmod.io.out(2), dmmod.io.out(1) )
    }.elsewhen(masksel === 2.U){
      regfmod.io.wdata := Cat( Fill(16, dmmod.io.out(3)(7)), dmmod.io.out(3), dmmod.io.out(2) )
    }.elsewhen(masksel === 3.U){
      regfmod.io.wdata := Cat( Fill(16, dmmod.io.out(0)(7)), dmmod.io.out(0) ,dmmod.io.out(3) )
    }



    }.elsewhen(cumod.io.instruction(14,12) === "b010".U ){ // load word
      regfmod.io.wdata := Cat(dmmod.io.out(3),dmmod.io.out(2),dmmod.io.out(1),dmmod.io.out(0))


    }.elsewhen(cumod.io.instruction(14,12) === "b100".U ){ // load byte un
      
      when(masksel=== 0.U){
      regfmod.io.wdata := Cat( Fill(24, dmmod.io.out(0)(7)) ,dmmod.io.out(0) )
    }.elsewhen(masksel === 1.U){
      regfmod.io.wdata := Cat( Fill(24, dmmod.io.out(1)(7)) ,dmmod.io.out(1) )
    }.elsewhen(masksel === 2.U){
      regfmod.io.wdata := Cat( Fill(24, dmmod.io.out(2)(7)) ,dmmod.io.out(2) )
    }.elsewhen(masksel === 3.U){
      regfmod.io.wdata := Cat( Fill(24, dmmod.io.out(3)(7)) ,dmmod.io.out(3) )
    }


    }.elsewhen(cumod.io.instruction(14,12) === "b101".U ){ // load half
      
      when(masksel=== 0.U){
      regfmod.io.wdata := Cat( Fill(16, dmmod.io.out(1)(7)), dmmod.io.out(1), dmmod.io.out(0) )
    }.elsewhen(masksel === 1.U){
      regfmod.io.wdata := Cat( Fill(16, dmmod.io.out(2)(7)), dmmod.io.out(2), dmmod.io.out(1) )
    }.elsewhen(masksel === 2.U){
      regfmod.io.wdata := Cat( Fill(16, dmmod.io.out(3)(7)), dmmod.io.out(3), dmmod.io.out(2) )
    }.elsewhen(masksel === 3.U){
      regfmod.io.wdata := Cat( Fill(16, dmmod.io.out(0)(7)), dmmod.io.out(0) ,dmmod.io.out(3) )
    }

    }

}


}

```



#### Error stacktrace:

```
scala.meta.internal.parsers.Reporter.syntaxError(Reporter.scala:16)
	scala.meta.internal.parsers.Reporter.syntaxError$(Reporter.scala:16)
	scala.meta.internal.parsers.Reporter$$anon$1.syntaxError(Reporter.scala:22)
	scala.meta.internal.parsers.Reporter.syntaxError(Reporter.scala:17)
	scala.meta.internal.parsers.Reporter.syntaxError$(Reporter.scala:17)
	scala.meta.internal.parsers.Reporter$$anon$1.syntaxError(Reporter.scala:22)
	scala.meta.internal.parsers.ScalametaParser.syntaxErrorExpected(ScalametaParser.scala:394)
	scala.meta.internal.parsers.ScalametaParser.syntaxErrorExpected(ScalametaParser.scala:392)
	scala.meta.internal.parsers.ScalametaParser.name(ScalametaParser.scala:1138)
	scala.meta.internal.parsers.ScalametaParser.termName(ScalametaParser.scala:1141)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$selector$1(ScalametaParser.scala:1197)
	scala.meta.internal.parsers.ScalametaParser.autoEndPos(ScalametaParser.scala:372)
	scala.meta.internal.parsers.ScalametaParser.selector(ScalametaParser.scala:1197)
	scala.meta.internal.parsers.ScalametaParser.simpleExprRest(ScalametaParser.scala:2149)
	scala.meta.internal.parsers.ScalametaParser.simpleExpr0(ScalametaParser.scala:2094)
	scala.meta.internal.parsers.ScalametaParser.simpleExpr(ScalametaParser.scala:2061)
	scala.meta.internal.parsers.ScalametaParser.prefixExpr(ScalametaParser.scala:2058)
	scala.meta.internal.parsers.ScalametaParser.argumentExprsOrPrefixExpr(ScalametaParser.scala:2286)
	scala.meta.internal.parsers.ScalametaParser.getNextRhs$2(ScalametaParser.scala:1945)
	scala.meta.internal.parsers.ScalametaParser.getPostfixOrNextRhs$1(ScalametaParser.scala:1979)
	scala.meta.internal.parsers.ScalametaParser.loop$6(ScalametaParser.scala:1999)
	scala.meta.internal.parsers.ScalametaParser.postfixExpr(ScalametaParser.scala:2023)
	scala.meta.internal.parsers.ScalametaParser.postfixExpr(ScalametaParser.scala:1926)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$expr$2(ScalametaParser.scala:1552)
	scala.meta.internal.parsers.ScalametaParser.atPosOpt(ScalametaParser.scala:327)
	scala.meta.internal.parsers.ScalametaParser.autoPosOpt(ScalametaParser.scala:370)
	scala.meta.internal.parsers.ScalametaParser.expr(ScalametaParser.scala:1480)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockStatSeq$3(ScalametaParser.scala:4234)
	scala.meta.internal.parsers.ScalametaParser.stat(ScalametaParser.scala:4091)
	scala.meta.internal.parsers.ScalametaParser.iter$7(ScalametaParser.scala:4234)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockStatSeq$1(ScalametaParser.scala:4247)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockStatSeq$1$adapted(ScalametaParser.scala:4197)
	scala.meta.internal.parsers.ScalametaParser.scala$meta$internal$parsers$ScalametaParser$$listBy(ScalametaParser.scala:562)
	scala.meta.internal.parsers.ScalametaParser.blockStatSeq(ScalametaParser.scala:4197)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockOnBrace$2(ScalametaParser.scala:2385)
	scala.meta.internal.parsers.ScalametaParser.inBracesOnOpen(ScalametaParser.scala:265)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockOnBrace$1(ScalametaParser.scala:2383)
	scala.meta.internal.parsers.ScalametaParser.atPos(ScalametaParser.scala:325)
	scala.meta.internal.parsers.ScalametaParser.autoPos(ScalametaParser.scala:369)
	scala.meta.internal.parsers.ScalametaParser.blockOnBrace(ScalametaParser.scala:2383)
	scala.meta.internal.parsers.ScalametaParser.blockOnBrace(ScalametaParser.scala:2385)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockExprOnBrace$1(ScalametaParser.scala:2388)
	scala.meta.internal.parsers.ScalametaParser.blockExprPartial(ScalametaParser.scala:2367)
	scala.meta.internal.parsers.ScalametaParser.blockExprOnBrace(ScalametaParser.scala:2387)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$getArgClauseOnBrace$1(ScalametaParser.scala:2320)
	scala.meta.internal.parsers.ScalametaParser.atPos(ScalametaParser.scala:325)
	scala.meta.internal.parsers.ScalametaParser.autoPos(ScalametaParser.scala:369)
	scala.meta.internal.parsers.ScalametaParser.getArgClauseOnBrace(ScalametaParser.scala:2319)
	scala.meta.internal.parsers.ScalametaParser.argClause$1(ScalametaParser.scala:2165)
	scala.meta.internal.parsers.ScalametaParser.simpleExprRest(ScalametaParser.scala:2166)
	scala.meta.internal.parsers.ScalametaParser.simpleExpr0(ScalametaParser.scala:2094)
	scala.meta.internal.parsers.ScalametaParser.simpleExpr(ScalametaParser.scala:2061)
	scala.meta.internal.parsers.ScalametaParser.prefixExpr(ScalametaParser.scala:2058)
	scala.meta.internal.parsers.ScalametaParser.postfixExpr(ScalametaParser.scala:1924)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$expr$2(ScalametaParser.scala:1552)
	scala.meta.internal.parsers.ScalametaParser.atPosOpt(ScalametaParser.scala:327)
	scala.meta.internal.parsers.ScalametaParser.autoPosOpt(ScalametaParser.scala:370)
	scala.meta.internal.parsers.ScalametaParser.expr(ScalametaParser.scala:1480)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockStatSeq$3(ScalametaParser.scala:4234)
	scala.meta.internal.parsers.ScalametaParser.stat(ScalametaParser.scala:4091)
	scala.meta.internal.parsers.ScalametaParser.iter$7(ScalametaParser.scala:4234)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockStatSeq$1(ScalametaParser.scala:4247)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockStatSeq$1$adapted(ScalametaParser.scala:4197)
	scala.meta.internal.parsers.ScalametaParser.scala$meta$internal$parsers$ScalametaParser$$listBy(ScalametaParser.scala:562)
	scala.meta.internal.parsers.ScalametaParser.blockStatSeq(ScalametaParser.scala:4197)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockOnBrace$2(ScalametaParser.scala:2385)
	scala.meta.internal.parsers.ScalametaParser.inBracesOnOpen(ScalametaParser.scala:265)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockOnBrace$1(ScalametaParser.scala:2383)
	scala.meta.internal.parsers.ScalametaParser.atPos(ScalametaParser.scala:325)
	scala.meta.internal.parsers.ScalametaParser.autoPos(ScalametaParser.scala:369)
	scala.meta.internal.parsers.ScalametaParser.blockOnBrace(ScalametaParser.scala:2383)
	scala.meta.internal.parsers.ScalametaParser.blockOnBrace(ScalametaParser.scala:2385)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$blockExprOnBrace$1(ScalametaParser.scala:2388)
	scala.meta.internal.parsers.ScalametaParser.blockExprPartial(ScalametaParser.scala:2367)
	scala.meta.internal.parsers.ScalametaParser.blockExprOnBrace(ScalametaParser.scala:2387)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$getArgClauseOnBrace$1(ScalametaParser.scala:2320)
	scala.meta.internal.parsers.ScalametaParser.atPos(ScalametaParser.scala:325)
	scala.meta.internal.parsers.ScalametaParser.autoPos(ScalametaParser.scala:369)
	scala.meta.internal.parsers.ScalametaParser.getArgClauseOnBrace(ScalametaParser.scala:2319)
	scala.meta.internal.parsers.ScalametaParser.argClause$1(ScalametaParser.scala:2165)
	scala.meta.internal.parsers.ScalametaParser.simpleExprRest(ScalametaParser.scala:2166)
	scala.meta.internal.parsers.ScalametaParser.simpleExpr0(ScalametaParser.scala:2094)
	scala.meta.internal.parsers.ScalametaParser.simpleExpr(ScalametaParser.scala:2061)
	scala.meta.internal.parsers.ScalametaParser.prefixExpr(ScalametaParser.scala:2058)
	scala.meta.internal.parsers.ScalametaParser.postfixExpr(ScalametaParser.scala:1924)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$expr$2(ScalametaParser.scala:1552)
	scala.meta.internal.parsers.ScalametaParser.atPosOpt(ScalametaParser.scala:327)
	scala.meta.internal.parsers.ScalametaParser.autoPosOpt(ScalametaParser.scala:370)
	scala.meta.internal.parsers.ScalametaParser.expr(ScalametaParser.scala:1480)
	scala.meta.internal.parsers.ScalametaParser$$anonfun$templateStat$1.applyOrElse(ScalametaParser.scala:4154)
	scala.meta.internal.parsers.ScalametaParser$$anonfun$templateStat$1.applyOrElse(ScalametaParser.scala:4147)
	scala.PartialFunction.$anonfun$runWith$1$adapted(PartialFunction.scala:145)
	scala.meta.internal.parsers.ScalametaParser.statSeqBuf(ScalametaParser.scala:4107)
	scala.meta.internal.parsers.ScalametaParser.getStats$2(ScalametaParser.scala:4137)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$scala$meta$internal$parsers$ScalametaParser$$templateStatSeq$3(ScalametaParser.scala:4138)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$scala$meta$internal$parsers$ScalametaParser$$templateStatSeq$3$adapted(ScalametaParser.scala:4136)
	scala.meta.internal.parsers.ScalametaParser.scala$meta$internal$parsers$ScalametaParser$$listBy(ScalametaParser.scala:562)
	scala.meta.internal.parsers.ScalametaParser.scala$meta$internal$parsers$ScalametaParser$$templateStatSeq(ScalametaParser.scala:4136)
	scala.meta.internal.parsers.ScalametaParser.scala$meta$internal$parsers$ScalametaParser$$templateStatSeq(ScalametaParser.scala:4128)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$templateBody$1(ScalametaParser.scala:4006)
	scala.meta.internal.parsers.ScalametaParser.inBracesOr(ScalametaParser.scala:260)
	scala.meta.internal.parsers.ScalametaParser.inBraces(ScalametaParser.scala:256)
	scala.meta.internal.parsers.ScalametaParser.templateBody(ScalametaParser.scala:4006)
	scala.meta.internal.parsers.ScalametaParser.templateBodyOpt(ScalametaParser.scala:4009)
	scala.meta.internal.parsers.ScalametaParser.templateAfterExtends(ScalametaParser.scala:3960)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$template$1(ScalametaParser.scala:3976)
	scala.meta.internal.parsers.ScalametaParser.atPos(ScalametaParser.scala:325)
	scala.meta.internal.parsers.ScalametaParser.autoPos(ScalametaParser.scala:369)
	scala.meta.internal.parsers.ScalametaParser.template(ScalametaParser.scala:3965)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$templateOpt$1(ScalametaParser.scala:4000)
	scala.meta.internal.parsers.ScalametaParser.atPos(ScalametaParser.scala:325)
	scala.meta.internal.parsers.ScalametaParser.autoPos(ScalametaParser.scala:369)
	scala.meta.internal.parsers.ScalametaParser.templateOpt(ScalametaParser.scala:3993)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$classDef$1(ScalametaParser.scala:3657)
	scala.meta.internal.parsers.ScalametaParser.autoEndPos(ScalametaParser.scala:372)
	scala.meta.internal.parsers.ScalametaParser.autoEndPos(ScalametaParser.scala:377)
	scala.meta.internal.parsers.ScalametaParser.classDef(ScalametaParser.scala:3635)
	scala.meta.internal.parsers.ScalametaParser.tmplDef(ScalametaParser.scala:3599)
	scala.meta.internal.parsers.ScalametaParser.topLevelTmplDef(ScalametaParser.scala:3589)
	scala.meta.internal.parsers.ScalametaParser$$anonfun$2.applyOrElse(ScalametaParser.scala:4121)
	scala.meta.internal.parsers.ScalametaParser$$anonfun$2.applyOrElse(ScalametaParser.scala:4115)
	scala.PartialFunction.$anonfun$runWith$1$adapted(PartialFunction.scala:145)
	scala.meta.internal.parsers.ScalametaParser.statSeqBuf(ScalametaParser.scala:4107)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$statSeq$1(ScalametaParser.scala:4096)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$statSeq$1$adapted(ScalametaParser.scala:4096)
	scala.meta.internal.parsers.ScalametaParser.scala$meta$internal$parsers$ScalametaParser$$listBy(ScalametaParser.scala:562)
	scala.meta.internal.parsers.ScalametaParser.statSeq(ScalametaParser.scala:4096)
	scala.meta.internal.parsers.ScalametaParser.bracelessPackageStats$1(ScalametaParser.scala:4285)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$source$1(ScalametaParser.scala:4288)
	scala.meta.internal.parsers.ScalametaParser.atPos(ScalametaParser.scala:325)
	scala.meta.internal.parsers.ScalametaParser.autoPos(ScalametaParser.scala:369)
	scala.meta.internal.parsers.ScalametaParser.source(ScalametaParser.scala:4264)
	scala.meta.internal.parsers.ScalametaParser.entrypointSource(ScalametaParser.scala:4291)
	scala.meta.internal.parsers.ScalametaParser.parseSourceImpl(ScalametaParser.scala:119)
	scala.meta.internal.parsers.ScalametaParser.$anonfun$parseSource$1(ScalametaParser.scala:116)
	scala.meta.internal.parsers.ScalametaParser.parseRuleAfterBOF(ScalametaParser.scala:58)
	scala.meta.internal.parsers.ScalametaParser.parseRule(ScalametaParser.scala:53)
	scala.meta.internal.parsers.ScalametaParser.parseSource(ScalametaParser.scala:116)
	scala.meta.parsers.Parse$.$anonfun$parseSource$1(Parse.scala:30)
	scala.meta.parsers.Parse$$anon$1.apply(Parse.scala:37)
	scala.meta.parsers.Api$XtensionParseDialectInput.parse(Api.scala:22)
	scala.meta.internal.semanticdb.scalac.ParseOps$XtensionCompilationUnitSource.toSource(ParseOps.scala:15)
	scala.meta.internal.semanticdb.scalac.TextDocumentOps$XtensionCompilationUnitDocument.toTextDocument(TextDocumentOps.scala:161)
	scala.meta.internal.pc.SemanticdbTextDocumentProvider.textDocument(SemanticdbTextDocumentProvider.scala:54)
	scala.meta.internal.pc.ScalaPresentationCompiler.$anonfun$semanticdbTextDocument$1(ScalaPresentationCompiler.scala:469)
```
#### Short summary: 

file%3A%2F%2F%2Fhome%2Fshehroz%2FDesktop%2FNew%2520Folder%25203%2FVermithor%2Fsrc%2Fmain%2Fscala%2Fcore%2Ftopcore.scala:130: error: `identifier` expected but `}` found
    }.elsewhen(cumod.io.instruction(14,12) === "b001".U ){ // load half
    ^