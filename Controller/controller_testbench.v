module controller_testbench;

  
//Inputs
  reg [15:0] IR;
  reg Clk;
  reg Reset;
  reg z;
  reg[4:0] state;
  
//Outputs
  wire [2:0] fnSel;
  wire  ldMAR, ldIR, ldPC, ldSP, ldMDR, ldReg, ldRegBank, TReg, TRegBank,       TSP, TMAR, TPC, TMDR, TLabel, MemRead, MemWrite, IRWrite;
  wire [4:0] nextstate;
  
//Instantiate unit
  controller uut(
    .IR(IR),
    .Clk(Clk),
    .Reset(Reset),
    .z(z),
    .fnSel(fnSel),
    .ldMAR(ldMAR), 
    .ldIR(ldIR), 
    .ldPC(ldPC), 
    .ldSP(ldSP), 
    .ldMDR(ldMDR), 
    .ldReg(ldReg), 
    .ldRegBank(ldRegBank), 
    .TReg(TReg), 
    .TRegBank(TRegBank),
    .TSP(TSP), 
    .TMAR(TMAR), 
    .TPC(TPC), 
    .TMDR(TMDR), 
    .TLabel(TLabel),
    .MemRead(MemRead), 
    .MemWrite(MemWrite), 
    .IRWrite(IRWrite),
    .state(state),
    .nextstate(nextstate)
  );
  
  
  initial begin
    // Initializing inputs
    IR = 0;
    Clk = 0;
    Reset = 0;
    z = 0;
    state = 0;
    $dumpfile("dump.vcd");
  $dumpvars;
    //Wait for 100 sec
    
    #100;
  IR = 16'b0000000000001111;
    #1000 $finish;
  //Reset = 0;
  end
  
  always #1 Clk=~Clk;
  always@(posedge Clk) state=nextstate;
  
  /*
  always@state begin
      if(state==0)begin
      #2;
      IR = 16'b0000000000001111;
    end
  end
  */

endmodule
    
    
  