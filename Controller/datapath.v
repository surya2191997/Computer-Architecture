module datapath(
fnSel, nextstate, ldMAR, ldIR, ldPC, ldSP, ldMDR, ldReg, ldRegBank, TReg, TRegBank,    // inputs
TSP, TMAR, TPC, TMDR, TLabel, MemRead, MemWrite, IRWrite,							   // inputs
IR, state,																			   // outputs
input Clk, Reset, z																       // ouptuts
);


output [15:0]IR;
output [4:0] state;


input [2:0] fnSel;
input [4:0] nextstate;
input Clk, Reset, z;
input ldMAR, ldIR, ldPC, ldSP, ldMDR, ldReg, ldRegBank, TReg, TRegBank, TSP, TMAR, TPC, TMDR, TLabel, MemRead, MemWrite, IRWrite;

wire[15:0] DataBus;
wire[15:0] xBus;
wire[15:0] zBus;
wire[15:0] buffer; //for buffer



Register MAR(zBus, xBus, ldMAR, TMAR, Clk, Reset);
Register SP(zBus, xBus, ldSP, TSP, Clk, Reset);
Register PC(zBus, xBus, ldPC, TPC, Clk, Reset);
Register R(xBus, buffer, ldReg, TReg, Clk, Reset);
Register IR(DataBus, xBus, ldIR, TLabel, Clk, Reset);

Register_ MDR(DataBus, zBus, xBus, ldMDR, TMDR, Clk, Reset);
//ALU A(xBus, buffer, fnSel, )


RegisterBank RB(zBus, IR, xBus, ldRegBank, TRegBank, Clk, Reset);



MainMemory MM;

endmodule




module Register(in, out, ld, T, Clk, Reset);

input[15:0] in;
input ld, T, Clk, Reset;
ouput[15:0] out;


reg[15:0] R;
reg[15:0] out;

always@(posedge Clk or posedge Reset)
	begin
		if(Reset)out=16'b0;
		else begin
			if(ld) R = in;
			else   R = R;
			if(T)  out = R;
			else   out = out;
		end
	end
endmodule






module Register_(in1, in2, out, ld, T, Clk, Reset);

input[15:0] in1;
input[15:0] in2;
input ld, T, Clk, Reset;
output[15:0] out;

reg[15:0] R;
reg[15:0] out;


always@(posedge Clk or posedge Reset)
	begin
		if(Reset)out=16'b0;
		else begin
			R = in1;
			if(ld) R = in2;
			else   R = R;
			if(T)  out = R;
			else   out = out;
		end
	end
endmodule




module decoder3to8(in, out1, out2, ld, T);
	input[2:0] in;
	input ld;
	output[7:0] out1;
	output[7:0] out2
	reg[7:0] out1, out2;
	
	always@(in or ld or T)
	begin
		if(ld)
		begin
			casex(in)
				3'b000:out1=8'b00000001;
				3'b001:out1=8'b00000010;
				3'b010:out1=8'b00000100;
				3'b011:out1=8'b00001000;
				3'b100:out1=8'b00010000;
				3'b101:out1=8'b00100000;
				3'b110:out1=8'b01000000;
				3'b111:out1=8'b10000000;
			endcase
		end

		else if(T)
		begin
			casex(in)
				3'b000:out2=8'b00000001;
				3'b001:out2=8'b00000010;
				3'b010:out2=8'b00000100;
				3'b011:out2=8'b00001000;
				3'b100:out2=8'b00010000;
				3'b101:out2=8'b00100000;
				3'b110:out2=8'b01000000;
				3'b111:out2=8'b10000000;
			endcase
		end
		else out=8'b00000000;
	end
endmodule







module RegisterBank(in, IR, out, ld, T, Clk, Reset);

input[15:0] in;
input[15:0] IR;
input ld, T, Clk, Reset;
output[15:0] out;


reg[15:0] out;
wire[7:0] ldReg;
wire[7:0] TReg;

decoder3to8(IR[8:10], ldReg, TReg, ld, T);



Register r0(in, out, ld&ldReg[0], T&TReg[0], Clk, Reset);
Register r1(in, out, ld&ldReg[1], T&TReg[1], Clk, Reset);
Register r2(in, out, ld&ldReg[2], T&TReg[2], Clk, Reset);
Register r3(in, out, ld&ldReg[3], T&TReg[3], Clk, Reset);
Register r4(in, out, ld&ldReg[4], T&TReg[4], Clk, Reset);
Register r5(in, out, ld&ldReg[5], T&TReg[5], Clk, Reset);
Register r6(in, out, ld&ldReg[6], T&TReg[6], Clk, Reset);
Register r7(in, out, ld&ldReg[7], T&TReg[7], Clk, Reset);

endmodule









































