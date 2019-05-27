module topmodule(Clk, Reset, state, nextstate);

input Clk, Reset;
  input[4:0] state;
output[4:0] nextstate;

wire[2:0] fnSel;
wire[4:0] state, nextstate;
wire[15:0] IR;
wire ldMAR, ldIR, ldPC, ldSP, ldMDR, ldReg, ldRegBank, TReg, TRegBank,    
TSP, TMAR, TPC, TMDR, TLabel, MemRead, MemWrite, IRWrite, flag;

datapath d(
fnSel, nextstate, ldMAR, ldIR, ldPC, ldSP, ldMDR, ldReg, ldRegBank, TReg, TRegBank,    // inputs
TSP, TMAR, TPC, TMDR, TLabel, MemRead, MemWrite, IRWrite, 							   // inputs
IR, state,																			   // outputs
Clk, Reset, flag																       // ouptuts
);


controller c(Clk, Reset, IR, flag, ldMAR, ldIR, ldPC, ldSP, ldMDR, ldReg, ldRegBank, TReg, TRegBank, TSP, TMAR, TPC, TMDR, TLabel, MemRead, MemWrite, IRWrite, fnSel, state, nextstate);


endmodule


