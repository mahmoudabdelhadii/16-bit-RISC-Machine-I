`define MREAD 2'b01
`define MWRITE 2'b10

`define reset 5'b00000
`define WImm 5'b00001
`define LA 5'b00101
`define LB 5'b00100
`define ALU 5'b00110
`define regW 5'b00111

`define readM2 5'b01001
`define writeMD 5'b01010
`define Mwrite 5'b01011
`define readM 5'b01100
`define setADR 5'b01101
`define LBR 5'b01110
`define ALU2 5'b01111
`define HALT 5'b11111

`define IF1 5'b01000
`define IF2 5'b10000
`define updatePC 5'b11000
`define decode 5'b11100

`define BL1 5'b00010
`define BL2 5'b00011
`define BX1 5'b10011
`define BX2 5'b10101
`define BX3 5'b10111
`define BLX 5'B11101

`define BEQ 5'b10010
`define BNE 5'b10100
`define BLT 5'b10110
`define BLE 5'b11010
`define B 5'b11110



module cpu(clk,reset, mem_addr, mem_cmd, read_data, write_data,HALTLED);
input clk, reset;
input [15:0] read_data;
output [15:0] write_data;
output [8:0] mem_addr;
output [1:0] mem_cmd;
output HALTLED;

wire [2:0] condition; //new

wire [2:0] readAndwrite,opcode;
wire [1:0] shift, op;
wire [15:0] sximm8;
wire [15:0] sximm5;
wire [11:0] FSM_out;
wire [15:0] Ireg_out;
wire [8:0] dataAddress;

wire[2:0] Z_out;

wire [1:0]psel; //new for PC mux
wire N,V,Z;

wire load_pc, load_addr, load_ir, reset_pc, addr_sel;

wire [8:0] next_pc,PC, intoOne,afterDataAddress;

wire HALTLED;

assign intoOne = (psel==2'b11)?(PC+1+sximm8):(psel==2'b00)?PC + 1:(psel==2'b10)?write_data:2'bxx;

vDFFE #(16) Instruction_Register(.clk(clk), .en(load_ir), .in(read_data), .out(Ireg_out)) ;

Instruction_Dec ID1(.in(Ireg_out), .nsel(FSM_out[11:9]),	//inputs
					.opcode(opcode), .op(op),				//to state machine
					.shift(shift), .sximm8(sximm8), .sximm5(sximm5), .readOrWrite(readAndwrite),.condition(condition));	//to Datapath

FSM stateMachine(.opcode(opcode),.op(op),.reset(reset),.out(FSM_out),.clk(clk),.mem_cmd(mem_cmd), .addr_sel(addr_sel),.load_pc(load_pc),.reset_pc(reset_pc),.load_addr(load_addr), .load_ir(load_ir),.Z_out(Z_out),.N(N),.V(V),.Z(Z),.condition(condition),.psel(psel),.HALTLED(HALTLED));


datapath DP(.mdata(read_data), .sximm8(sximm8), .sximm5(sximm5), .PC(PC), .writenum(readAndwrite), .write(FSM_out[0]), 
			.readnum(readAndwrite), .clk(clk), .asel(FSM_out[3]), .bsel(FSM_out[4]), .vsel(FSM_out[4:3]), .loadb(FSM_out[6]), .loada(FSM_out[5]), .loadc(FSM_out[7]), .loads(FSM_out[8]), .shift(shift), .ALUop(FSM_out[6:5]), 
			.datapath_out(write_data), .Z_out(Z_out), .N(N), .V(V), .Z(Z));
			

MUX #(9) PCMUX(.a(9'b0),.b(intoOne), .sel(reset_pc),.out(next_pc));
//module MUX(a,b,sel,out)

vDFFE #(9) ProgramCounter(.clk(clk), .en(load_pc), .in(next_pc), .out(PC));
vDFFE #(9) DataAddress(.clk(clk), .en(load_addr), .in(write_data[8:0]), .out(dataAddress));
//module vDFFE(clk, en, in, out)

MUX #(9) memSelect(.a(PC), .b(dataAddress),.sel(addr_sel),.out(mem_addr));




endmodule
module Instruction_Dec(in, nsel, opcode, op, shift, sximm8, sximm5, readOrWrite,condition);
input [15:0] in;
input [2:0] nsel;

output [1:0] op,shift;
output [2:0] condition;
reg [1:0] shift;
output [2:0] opcode;
output [15:0] sximm8; //specify datapath size
output [15:0] sximm5;
output [2:0] readOrWrite; //check wire/reg here - writenum and readnum

wire [2:0] rORw;


assign opcode = in[15:13];
assign op = in [12:11];
assign condition = in[10:8];
assign sximm8 = {{8{in[7]}}, in [7:0] };
assign sximm5 = {{11{in[4]}}, in [4:0] };
assign readOrWrite = rORw;

always @(*)
if (opcode == 3'b110 || opcode == 3'b101)
	shift = in[4:3];
else
	shift = 2'b00;


writeAndRead_Mux M1(.Rn(in[10:8]),.Rd(in[7:5]),.Rm(in[2:0]), .nsel(nsel),.readOrWrite(rORw) );


endmodule

module writeAndRead_Mux(Rn, Rd, Rm, nsel, readOrWrite);
input [2:0] Rn, Rd, Rm, nsel;

output [2:0] readOrWrite;

reg [2:0] readOrWrite;

always@*begin
	case(nsel)
		3'b001: readOrWrite = Rn;
		3'b010: readOrWrite = Rd;
		3'b100: readOrWrite = Rm;
		default: readOrWrite = 3'bxxx;
		
		//continue those
	endcase
end
endmodule





module FSM(opcode,op,reset,out,clk,mem_cmd, addr_sel,load_pc,reset_pc, load_addr,condition, load_ir,Z_out,N,V,Z,psel,HALTLED);
input clk;
input[2:0] opcode;
input[1:0] op;
input reset;


input [2:0]condition;
input N,V,Z;
input[2:0] Z_out;
output  reg HALTLED;  //LEDR[8]

output[11:0] out;
output addr_sel,load_pc,reset_pc,load_addr, load_ir;
output [1:0] mem_cmd;

output reg [1:0]psel;

reg[11:0] out;
reg addr_sel,load_pc,reset_pc,load_addr, load_ir;
reg [1:0] mem_cmd;

reg[4:0] state;

always@ (posedge clk) begin
	
	casex ({state,reset,opcode,op,condition})
		
		//reset
		14'bxxxxx_1_xxx_xx_xxx : state = `reset; //reset state is still 00000
		
		//reset stage
		{`reset,9'b0_xxx_xx_xxx} : state = `IF1;	//advance to IF1

		//state 01000 IF1
		{`IF1,9'b0_xxx_xx_xxx} : state = `IF2;	//advance to IF2

		//state 10000 IF2
		{`IF2,9'b0_xxx_xx_xxx} : state = `updatePC;	//advance to UpdatePC

		//state 11000 UpdatePC
		{`updatePC,9'b0_xxx_xx_xxx} : state = `decode;	//advance to decode
		
		//state 11100 decode
		{`decode,9'b0_110_10_xxx} : state = `WImm;	//MOV Rn,#<im8>
		{`decode,9'b0_110_00_xxx} : state = `LB;	//MOV Rd,Rm{,<sh_op>}
		{`decode,9'b0_101_xx_xxx} : state = `LB;	//ALU instructions
		{`decode,9'b0_011_00_xxx} : state = `LA;	//LDR
		{`decode,9'b0_100_00_xxx} : state = `LA;	//STR
		{`decode,9'b0_111_xx_xxx} : state = `HALT;	//HALT
		{`decode,9'b0_001_00_000} : state = `B;
		{`decode,9'b0_001_00_001} : state = `BEQ;
		{`decode,9'b0_001_00_010} : state = `BNE;
		{`decode,9'b0_001_00_011} : state = `BLT;
		{`decode,9'b0_010_00_100} : state = `BLE;

		{`decode,9'b0_010_11_xxx} : state = `BL1;
		{`decode,9'b0_010_00_xxx} : state = `BX1;
		{`decode,9'b0_010_10_xxx} : state = `BL1;
		
		//  ^^^ changed them to start taking messages from the decode state

		//state 00100 Load B
		{`LB,9'b0_101_0x_xxx} : state = `LA;	//Load A
		{`LB,9'b0_101_10_xxx} : state = `LA;	//Load A 
		{`LB,9'b0_110_00_xxx} : state = `ALU;	//ALU
		{`LB,9'b0_101_11_xxx} : state = `ALU;	//ALU


		//state 00001 writeImm
		{`WImm,9'b0_xxx_xx_xxx} : state = `IF1; 	//IF1

		//state BXX to IF1
		{`B,9'b0_xxx_xx_xxx} : state = `IF1;   //stage 1
		{`BEQ,9'b0_xxx_xx_xxx} : state = `IF1;
		{`BNE,9'b0_xxx_xx_xxx} : state = `IF1;
		{`BLT,9'b0_xxx_xx_xxx} : state = `IF1;
		{`BLE,9'b0_xxx_xx_xxx} : state = `IF1;

		//BL1 TO BL2
		{`BL1,9'b0_010_11_xxx} : state = `BL2; //BL2
		{`BX1,9'b0_010_x0_xxx} : state = `BX2;
		
		//BLX BL1 to BX1
		{`BL1,9'b0_010_10_xxx} : state = `BX1;
		//BX2 to BX3
		{`BX2,9'b0_010_00_xxx} : state = `BX3;
		
		
		//BL2 to IF1						stage 2 to IF1

		{`BL2,9'b0_xxx_xx_xxx} : state = `IF1; //BL2
		
		
		
		{`BX3,9'b0_xxx_xx_xxx} : state = `IF1; //BX


		
		
		//state 00101 Load A
		{`LA,9'b0_xxx_xx_xxx} : state = `ALU;	//always goes to ALU
		
		//state 00110 ALU operations
		{`ALU,9'b0_101_01_xxx} : state = `regW;	//CMP - IF1
		{`ALU,9'b0_110_00_xxx} : state =`regW;	//writereg
		{`ALU,9'b0_101_00_xxx} : state = `regW;	//writereg
		{`ALU,9'b0_101_1x_xxx} : state = `regW;	//writereg
		{`ALU,9'b0_011_00_xxx} : state = `readM;	//LDR - ReadMem
		{`ALU,9'b0_100_00_xxx} : state = `setADR;	//STR - SetARD
		
		//state 00111 writeReg
		{`regW,9'b0_xxx_xx_xxx} : state = `IF1;
		
		//state 01100 readMem (LDR)
		{`readM,9'b0_xxx_xx_xxx} : state = `readM2;	//always goes to writeMD
		
		//state 01001 readMem2 (LDR)
		{`readM2,9'b0_xxx_xx_xxx} : state = `writeMD;
		
		//state 01010 WriteMD (LDR)
		{`writeMD,9'b0_xxx_xx_xxx} : state = `IF1;	//always goes to IF1
		
		//state 01101 SetADR (STR)
		{`setADR,9'b0_xxx_xx_xxx} : state = `LBR;	//always goes to LoadBR
		
		//state 01110 LoadBR (STR)
		{`LBR,9'b0_xxx_xx_xxx} : state = `ALU2;	//always goes to ALU2
		
		//state 01111 ALU2 (STR)
		{`ALU2,9'b0_xxx_xx_xxx} : state = `Mwrite;	//always goes to Mwrite
		
		//state 01011 Mwrite (STR)
		{`Mwrite,9'b0_xxx_xx_xxx} : state = `IF1;	//always goes to IF1

		//state 11111 HALT
		{`HALT,9'b0_xxx_xx_xxx} : state = `HALT;
		
		default : state = 5'bxxxxx;
	endcase
	
	case ({state,N,V,Z})

		//reset
		{`reset,3'bxxx} : begin 
		out = 12'b000_00000000_0;
			//w = 2'b01;
		reset_pc = 1;
		load_pc  = 1;
		HALTLED=1'b0;
		end
		
		//IF1
		{`IF1,3'bxxx} : begin
		out = 12'b000_00000000_0;
		reset_pc = 1'b0;
		load_pc = 0;
		addr_sel = 1;
		mem_cmd = `MREAD;
		end
		
		//IF2
		{`IF2,3'bxxx} : begin
		addr_sel = 1;
		mem_cmd = `MREAD;
		load_ir = 1;
		end

		//Update PC
		{`updatePC,3'bxxx} : begin
		mem_cmd = 2'b0;
		load_ir = 0;
		load_pc = 1;
		end

		//Decode
		{`decode, 3'bxxx}: begin
			load_pc = 0;
			out = 12'b0000000_11_000;	//defaults selects to 1
		end
		
		//writeImm
		{`WImm,3'bxxx} : begin
			out = 12'b001_0000_10_00_1;
		end
		
		//loadB
		{`LB,3'bxxx} : begin
			out = {(7'b100_0010), 2'b01, (3'b0)};
		end
		
		//loadA
		{`LA,3'bxxx} : begin
		out = {(7'b001_0001),out[4], 1'b0, (3'b0)};
		end
		//ALU instructions
		{`ALU,3'bxxx} : begin 
		out = {3'b000_,({opcode,op}==5'b10101 ? 1 : 0),1'b1,op,out[4],out[3],3'b00_0};
		end
		//writeReg
		{`regW,3'bxxx} : begin
		out = 12'b010_00000000_1;
		end
		//readMem
		{`readM,3'bxxx}: begin
		load_addr = 1; addr_sel = 0; mem_cmd = `MREAD;
		end
		
		//readMem2
		{`readM2,3'bxxx} : begin
		end
		
		//writeMD
		{`writeMD,3'bxxx} : begin
		out = 12'b010_000011001;
		end
		
		//SetADR
		{`setADR,3'bxxx} : begin
		load_addr = 1; addr_sel = 0;
		end
		
		//LoadBR
		{`LBR,3'bxxx} : begin
		out = {(7'b010_0010), 2'b01, (3'b0)};
		end
		
		//ALU2
		{`ALU2,3'bxxx} : begin
		out = {5'b000_01,op,out[4],out[3],3'b00_0};
		end
		
		//Mwrite
		{`Mwrite,3'bxxx} : begin
		mem_cmd = `MWRITE;
		end
		
		//HALT
		{`HALT,3'bxxx} : begin
		HALTLED = 1'b1;
		end
		
		{`B,3'bxxx}: begin
		psel= 2'b00;
		end

		{`BEQ,3'bxx1}: begin  //BEQ  Z=1
		psel= 2'b11;
		end
		{`BEQ,3'bxx0}: begin  //BEQ  Z=0
		psel= 2'b00;
		end

		{`BNE,3'bxx0}: begin  //BNE  Z=0
		psel= 2'b11;
		end
		{`BNE,3'bxx1}: begin  //BNE  Z=0
		psel= 2'b00;
		end

		{`BLT,3'b10x}: begin  //BLT N!=V
		psel= 2'b11;
		end
		{`BLT,3'b01x}: begin  //BLT N!=V
		psel= 2'b11;
		end

		{`BLT,3'b11x}: begin  //BLT N!=V
		psel= 2'b00;
		end
		{`BLT,3'b00x}: begin  //BLT N!=V
		psel= 2'b00;
		end

		{`BLE,3'b10x}: begin  // BLE N!=V 
		psel= 2'b11;
		end

		{`BLE,3'b01x}: begin  // BLE N!=V 
		psel= 2'b11;
		end

		{`BLE,3'bxx1}: begin  // BLE  Z=1
		psel= 2'b11;
		end
		{`BL1,3'bxxx}: begin  // BL  R7=PC
		out = 12'b001_00000000_1;
		end

		{`BL2,3'bxxx}: begin  // BL  PC PC+1+sx(imm8)
		psel=2'b11;
		end

		
		{`BX1,3'bxxx}: begin  // BL  R7=PC
		out = {(7'b010_0010), 2'b01, (3'b0)};  //GET number from reg r7(Rd) bsel=0,asel=1,
		
		end

		{`BX2,3'bxxx}: begin  // BL  R7=PC
		out = {3'b000_,1'b0,1'b1,op,out[4],out[3],3'b00_0};   //ALU
		load_pc= 1;
		end
		
		{`BX3,3'bxxx}: begin  
		psel=2'b10;					 //LOADS DATA OUT TO PC REGISTER
		load_pc= 1;
	
		end

		default : out = 12'b000000000000;
		
			
		
	endcase
	
	
end

endmodule







