module testbench(Clk, Reset, state, nextstate);


output Clk, Reset;
output[4:0] state;

input[4:0] nextstate;
reg[4:0] state;
reg Clk, Reset;
  
topmodule tp(Clk, Reset, state, nextstate);


initial begin
$display("Current values : \n");
Clk = 0;
Reset = 0;
state = 0;

$dumpfile("dump.vcd");
$dumpvars;
 //Wait for 100 sec
 #10;

 #1000 $finish;
end

always #1 Clk=~Clk;
  always@(negedge Clk) 
begin

  $display ("State = %d  PC = %d  sp = %d  r0 = %d  r1 = %d  mem[0] = %d  mem[1] = %d  mem[2] = %d", state, tp.d.PC.R,  tp.d.SP.R, tp.d.RB.r0.R, tp.d.RB.r1.R, tp.d.MM.memory[0], tp.d.MM.memory[1], tp.d.MM.memory[2]);
  
  state=nextstate;
 
end



endmodule

