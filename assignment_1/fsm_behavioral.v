/* 
Group 50
Assignment 1
Behavioral encoding of FSM in Verilog
*/


// testbench
module testBench(clk,rst,in,out);
output reg clk, in, rst;
input out;
reg[15:0] sequence;
integer i;
fsm f(clk,rst,in,out);
initial
begin

clk = 0;
rst = 1;
sequence = 16'b0101_0111_0111_0010;
#5 rst = 0;

for( i = 0; i <= 15; i = i + 1)
begin
in = sequence[i];
#2 clk = 1;
#2 clk = 0;
$display("State = ", f.state, " Input = ", in, ", Output = ", out);

end
test2;
end

task test2;
for( i = 0; i <= 15; i = i + 1)
begin
in = $random % 2;
#2 clk = 1;
#2 clk = 0;
$display("State = ", f.state, " Input = ", in, ", Output = ", out);

end
endtask

endmodule





// finite state machine
module fsm(clk,rst,in,out);
input clk,rst,in;
output out;

reg [1:0] state;
reg out;

always @(posedge clk, posedge rst) begin
if(rst) begin
state <= 2'b00;
out <= 0;
end
else begin
case( state )
2'b00 : begin
if(in) begin
state <= 2'b10;
out <= 0;
end
else begin
state <= 2'b01;
out <= 0;
end
end

2'b01 : begin
if(in) begin
state <= 2'b10;
out <= 1;
end
else begin
state <= 2'b00;
out <= 0;
end
end

2'b10 : begin
if(in) begin
state <= 2'b11;
out <= 0;
end
else begin
state <= 2'b01;
out <= 0;
end
end

2'b11 : begin
if(in) begin
state <= 2'b10;
out <= 0;
end
else begin
state <= 2'b01;
out <= 1;
end
end

default: begin
state <= 2'b00;
out <= 0;
end
endcase
end
end

endmodule
