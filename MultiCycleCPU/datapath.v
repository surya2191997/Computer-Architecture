module datapath(
fnSel, nextstate, ldMAR, ldIR, ldPC, ldSP, ldMDR, ldReg, ldRegBank, TReg, TRegBank,    // inputs
TSP, TMAR, TPC, TMDR, TLabel, MemRead, MemWrite, IRWrite, 						  	   // inputs
IR, state,																			   // outputs
Clk, Reset, flag																   // ouptuts
);


output [15:0]IR;
output [4:0] state;


input [2:0] fnSel;
input [4:0] nextstate;
input Clk, Reset, flag;
input ldMAR, ldIR, ldPC, ldSP, ldMDR, ldReg, ldRegBank, TReg, TRegBank, TSP, TMAR, TPC, TMDR, TLabel, MemRead, MemWrite, IRWrite;

  wire[15:0] DataBus;
wire[15:0] xBus; 
wire[15:0] zBus;
wire[15:0] buffer; //for buffer

wire[15:0] IR;

wire cin, zin, vin, sin;


Register MAR(zBus, xBus, ldMAR, TMAR, Clk, Reset);
Register Buff(xBus, buffer, ldReg, TReg, Clk, Reset);
Register_SP SP(zBus, xBus, ldSP, TSP, Clk, Reset);
Register_PC PC(zBus, xBus, ldPC, TPC, Clk, Reset);
Register_IR IR_(DataBus, xBus, IR, IRWrite, TLabel, Clk, Reset);

Register_MDR MDR(zBus, xBus, DataBus, ldMDR, TMDR, MemRead, MemWrite, Clk, Reset);
ALU A(xBus, buffer, zBus, fnSel, cin, zin, vin, sin, Clk, Reset);
StatusDetector sd(cin, zin, vin, sin, IR, flag, Clk, Reset);

RegisterBank RB(zBus, IR, xBus, ldRegBank, TRegBank, Clk, Reset);

MainMemory MM(MAR.R, DataBus, MemRead, MemWrite, Clk, Reset);

endmodule



module MainMemory(address, DataBus, MemRead, MemWrite, Clk, Reset);

input[15:0] address;
input Clk, Reset;
input MemRead, MemWrite;
output[15:0] DataBus;



reg[15:0] memory[200:0];
wire[15:0] DataBus;

initial
begin

  	// data area of the memory. SP is initialized to 0
 	memory[0] = 16'b0000000000000111;    // a = 7
  	memory[1] = 16'b0000000000000011;    // b = 3
  	memory[2] = 16'b0000000000000001;    // c = 1
  
    // Following program computes a + b - c and stores the result
	// Instruction area of the memory. PC is initialized to 20
 	memory[20] = 16'b0000000000101111;	 // pop r0
  	memory[21] = 16'b0000000000111111;	 // add r0
  	memory[22] = 16'b0000010010111111;	 // neg r1
 	memory[23] = 16'b0000010000001111;	 // push r1
  	memory[24] = 16'b0000000000111111; 	 // add r0
  	memory[25] = 16'b0000000000001111;	 // push r0
  

  
end



assign DataBus = (MemRead) ? memory[address] : 'bz; 

always@*
begin
if(MemWrite) memory[address] = DataBus;
end


endmodule



module Register(in, out, ld, T, Clk, Reset);

input[15:0] in;
input ld, T, Clk, Reset;
output[15:0] out;


reg[15:0] R;
wire[15:0] out;

  always@(posedge Clk or posedge Reset)
	begin
			if(ld) R = in;
			else   R = R;
	end


  assign out = (T) ? R : 'bz; 

endmodule



module Register_PC(in, out, ld, T, Clk, Reset);

input[15:0] in;
input ld, T, Clk, Reset;
output[15:0] out;


reg[15:0] R;
wire[15:0] out;

initial R = 16'b0000000000010100;


  always@(posedge Clk or posedge Reset)
	begin		
			if(ld) R = in;
			else   R = R;
	end


   assign out = (T) ? R : 'bz;

endmodule




module Register_SP(in, out, ld, T, Clk, Reset);

input[15:0] in;
input ld, T, Clk, Reset;
output[15:0] out;


reg[15:0] R;
wire[15:0] out;


initial R = 16'b0000000000000000;

  always@(posedge Clk or posedge Reset)
	begin
			if(ld) R = in;
			else   R = R;
	end

 assign out = (T) ? R : 'bz;

endmodule





module Register_IR(in, out, IR, ld, T, Clk, Reset);

input[15:0] in;
input ld, T, Clk, Reset;
output[15:0] out;
output[15:0] IR;

reg[15:0] IR;
wire[15:0] out;

  always@(posedge Clk or posedge Reset)
	begin
      if(Reset)IR=16'b0;
		else begin
          if(ld) IR = in;
			else   IR = IR;	
		end
	end

  assign out = (T) ? IR : 'bz;

endmodule





module Register_MDR(in, out1, out2, ld, T, ld1, T1, Clk, Reset);

input[15:0] in;
input ld, T, ld1, T1, Clk, Reset;
  output[15:0] out1, out2;

reg[15:0] R;
wire[15:0] out1, out2;


  always@(posedge Clk or posedge Reset)
	begin
		if(Reset) R=16'b0;
		else begin
			if(ld) R = out1;
			else R = R;
			if(ld1) R = out2;
			else R = R;
		end
	end


  
  assign out1 = (T) ? R : 'bz;
  assign out2 = (T1) ? R : 'bz;
  
  
  
endmodule




module decoder3to8(in, out, cs);
  	input[15:0] in;
	input cs;
	output[7:0] out;
	reg[7:0] out;

	
	always@*
	begin
		if(cs)
		begin
          casex(in[10:8])
				3'b000:out=8'b00000001;
				3'b100:out=8'b00000010;
				3'b010:out=8'b00000100;
				3'b110:out=8'b00001000;
				3'b001:out=8'b00010000;
				3'b101:out=8'b00100000;
				3'b011:out=8'b01000000;
				3'b111:out=8'b10000000;
			endcase
		end
		else	out = 8'b0;

	end
endmodule





module RegisterBank(in, IR, out, ld, T, Clk, Reset);

input[15:0] in;
input[15:0] IR;
input ld, T, Clk, Reset;
output[15:0] out;


wire[15:0] out;
wire[7:0] ldReg;
wire[7:0] TReg;

decoder3to8 d1(IR, ldReg, ld);
decoder3to8 d2(IR, TReg, T);

Register r0(in, out, ld&ldReg[0], T&TReg[0], Clk, Reset);
Register r1(in, out, ld&ldReg[1], T&TReg[1], Clk, Reset);
Register r2(in, out, ld&ldReg[2], T&TReg[2], Clk, Reset);
Register r3(in, out, ld&ldReg[3], T&TReg[3], Clk, Reset);
Register r4(in, out, ld&ldReg[4], T&TReg[4], Clk, Reset);
Register r5(in, out, ld&ldReg[5], T&TReg[5], Clk, Reset);
Register r6(in, out, ld&ldReg[6], T&TReg[6], Clk, Reset);
Register r7(in, out, ld&ldReg[7], T&TReg[7], Clk, Reset);

endmodule



module ALU(inx, iny, outz, fnSel, cin, zin, vin, sin, Clk, Reset);

input[15:0] inx;
input[15:0] iny;
input[2:0] fnSel;
input Clk, Reset;
output[15:0] outz;
output cin, zin, vin, sin;

reg[16:0] temp;
reg[15:0] outz;
reg cin, vin;
wire zin, sin;

parameter def = 0;
parameter trans=1;
parameter inc=2;
parameter dec=3;
parameter add=4;
parameter not_=5;
parameter neg=6;
parameter or_=7;

nand  n1(zin,outz[15],outz[14],outz[13],outz[12],outz[11],outz[10],outz[9],outz[8],outz[7],outz[6],outz[5],outz[4],outz[3],outz[2],outz[1],outz[0]);  
  
assign sin = outz[15];

always@*
begin
case(fnSel)
	trans:
	begin
	outz = inx;
	end

	inc:
	begin
	temp = inx + 1;
	outz = temp[15:0];
	cin = temp[16];
	vin = 0;
	end


	dec:
	begin
	outz = inx - 1;
	cin = 0;
	vin = 0;
	end

	add:
	begin
	temp = inx + iny;
	outz = temp[15:0];
	cin = temp[16];
	vin = 0;
	end

	not_:
	begin
	outz = ~inx;
	cin = 0;
	vin = 0;
	end

	neg:
	begin
	outz = -inx;
	cin = 0;
	vin = 0;
	end
	
	or_:
	begin
	outz = inx | iny;
	cin = 0;
	vin = 0;
	end

	def:
    begin
	cin = 0;
	vin = 0;
    end
  endcase
end

endmodule




module StatusDetector(cin, zin, vin, sin, IR, flag, Clk, Reset);

input cin, zin, vin, sin, Clk ,Reset;
input[15:0] IR;
output flag;

wire[15:0] cond;

dff cin_ff(cond[1], cond[2], cin, Clk);
dff zin_ff(cond[3], cond[4], zin, Clk);
dff vin_ff(cond[5], cond[6], vin, Clk);
dff sin_ff(cond[7], cond[8], sin, Clk);

mux16to1 m(cond, IR, flag);
endmodule




module mux16to1(cond, IR, flag);

input[15:0] cond;
input[15:0] IR;
output flag;
reg flag;

always@*
begin
  case(IR[10:8])
	3'b000 :
	flag = 1;

	3'b001 : 
	flag = cond[1];

	3'b010: 
	flag = cond[2];

	3'b011: 
	flag = cond[3];

	3'b100:
	flag = cond[4];

	3'b101:
	flag = cond[5];

	3'b110:
	flag = cond[6];

	3'b111:
	flag = cond[7];
endcase
end
endmodule




module dff(q,q1,d,Clk);
output q,q1;
input d,c, Clk;
reg q,q1;
	
	initial 
	  begin
		   q=1'b0; 
		   q1=1'b1;
	  end
	
  always @ (posedge Clk)
	   begin 
		 q=d;
		 q1= ~d;
	   end
endmodule



