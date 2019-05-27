/* 
Group 50
Assignment 1
Structural encoding of FSM in Verilog
*/


// top module
module top;
wire clk,rst,in,out;
testBench tb(clk,rst,in,out);
fsm f(clk,rst,in,out);
endmodule




// testbench
module testBench(clk,rst,inp,outp);

output clk,rst,inp;
input outp;


reg clk, rst, inp;
wire outp;
reg[15:0] sequence;
integer i;


initial
begin

clk = 0;
rst = 1;

sequence = 16'b0101_0111_0111_0010;
#5 rst = 0;

for( i = 0; i <= 15; i = i + 1)
begin
inp = sequence[i];
#2 clk = 1;
#2 clk = 0;
  
if(i>1)
$display( " Input = ", inp, ", Output = ", outp);

end

test2;
end
task test2;
for( i = 0; i <= 15; i = i + 1)
begin
inp = $random % 2;
#2 clk = 1;
#2 clk = 0;
$display( " Input = ", inp, ", Output = ", outp);

end
endtask


endmodule





// finite state machine
module fsm(clk,rst,in,out);
input clk,rst,in;
output out;

wire[1:0] y;
wire[1:0] Y;

StateTransitionFn sf(clk,rst,in,y,Y);
outputFn of(clk,rst,in,out,y);
delayElement d(clk,y,Y);

endmodule



// state transition function
module StateTransitionFn(clk,rst,in,y,Y);
input clk,rst,in;
input[1:0] y;
output[1:0] Y;
reg[1:0] Y;


always @(posedge clk, posedge rst) begin
if(rst) begin
Y[0] = 0;
Y[1] = 0;
end

else begin
Y[0] = in;
Y[1] = (~in&~y[1]) + (~in&y[0]) + (y[0]&~y[1]);
end

end

endmodule




// output function
module outputFn(clk,rst,in,out,y);
input clk,rst,in;
input[1:0] y;
output out;
reg out;

always @(posedge clk, posedge rst) begin
if(rst) begin
out <= 0;
end
else begin
out <= (in&~y[0]&y[1]) + (~in&y[0]&y[1]);
end
end

endmodule



// flip flop
module delayElement(clk,y,Y);
input clk;
input[1:0] Y;
output[1:0] y;
reg[1:0] y;

always @ (posedge clk) begin
y[0] <= Y[0];
end

always @ (posedge clk) begin
y[1] <= Y[1];
end
endmodule

