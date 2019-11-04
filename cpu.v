`define MREAD 2'b01
`define MWRITE 2'b10

module cpu(clk,reset, mem_addr, mem_cmd, read_data, write_data);
input clk, reset;
input [15:0] read_data;
output [15:0] write_data;
output [8:0] mem_addr;
output [1:0] mem_cmd;

wire [2:0] readAndwrite,opcode;
wire [1:0] shift, op;
wire [15:0] sximm8;
wire [15:0] sximm5;
wire [11:0] FSM_out;
wire [15:0] Ireg_out;
wire [8:0] dataAddress;

wire load_pc, load_addr, load_ir, reset_pc, addr_sel;

wire [8:0] next_pc,PC, intoOne,afterDataAddress;

assign intoOne = PC + 1;

vDFFE #(16) Instruction_Register(.clk(clk), .en(load_ir), .in(read_data), .out(Ireg_out)) ;

Instruction_Dec ID1(.in(Ireg_out), .nsel(FSM_out[11:9]),	//inputs
					.opcode(opcode), .op(op),				//to state machine
					.shift(shift), .sximm8(sximm8), .sximm5(sximm5), .readOrWrite(readAndwrite));	//to Datapath

FSM stateMachine(.opcode(opcode),.op(op),.reset(reset),.out(FSM_out),.clk(clk),.mem_cmd(mem_cmd), .addr_sel(addr_sel),.load_pc(load_pc),.reset_pc(reset_pc),.load_addr(load_addr), .load_ir(load_ir));


datapath DP(.mdata(read_data), .sximm8(sximm8), .sximm5(sximm5), .PC(8'b0), .writenum(readAndwrite), .write(FSM_out[0]), 
			.readnum(readAndwrite), .clk(clk), .asel(FSM_out[3]), .bsel(FSM_out[4]), .vsel(FSM_out[4:3]), .loadb(FSM_out[6]), .loada(FSM_out[5]), .loadc(FSM_out[7]), .loads(FSM_out[8]), .shift(shift), .ALUop(FSM_out[6:5]), 
			.datapath_out(write_data), .Z_out(), .N(), .V(), .Z());
			

MUX #(9) PCMUX(.a(9'b0),.b(intoOne), .sel(reset_pc),.out(next_pc));
//module MUX(a,b,sel,out)

vDFFE #(9) ProgramCounter(.clk(clk), .en(load_pc), .in(next_pc), .out(PC));
vDFFE #(9) DataAddress(.clk(clk), .en(load_addr), .in(write_data[8:0]), .out(dataAddress));
//module vDFFE(clk, en, in, out)

MUX #(9) memSelect(.a(PC), .b(dataAddress),.sel(addr_sel),.out(mem_addr));




endmodule
module Instruction_Dec(in, nsel, opcode, op, shift, sximm8, sximm5, readOrWrite);
input [15:0] in;
input [2:0] nsel;

output [1:0] op,shift;
reg [1:0] shift;
output [2:0] opcode;
output [15:0] sximm8; //specify datapath size
output [15:0] sximm5;
output [2:0] readOrWrite; //check wire/reg here - writenum and readnum

wire [2:0] rORw;


assign opcode = in[15:13];
assign op = in [12:11];
//assign shift = in[4:3];
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



module FSM(opcode,op,reset,out,clk,mem_cmd, addr_sel,load_pc,reset_pc, load_addr, load_ir);
input clk;
input[2:0] opcode;
input[1:0] op;
input reset;

output[11:0] out;
output addr_sel,load_pc,reset_pc,load_addr, load_ir;
output [1:0] mem_cmd;

reg[11:0] out;
reg addr_sel,load_pc,reset_pc,load_addr, load_ir;
reg [1:0] mem_cmd;

reg[4:0] state;

always@ (posedge clk) begin
	
	casex ({state,reset,opcode,op})
		
		//reset
		11'bxxxxx_1_xxx_xx : state = 0; //reset state is still 00000
		
		//reset stage
		11'b00000_0_xxx_xx : state = 5'b01000;	//advance to IF1

		//state 01000 IF1
		11'b01000_0_xxx_xx : state = 5'b10000;	//advance to IF2

		//state 10000 IF2
		11'b10000_0_xxx_xx : state = 5'b11000;	//advance to UpdatePC

		//state 11000 UpdatePC
		11'b11000_0_xxx_xx : state = 5'b11100;	//advance to decode
		
		//state 11100 decode
		11'b11100_0_110_10 : state = 5'b00001;	//MOV Rn,#<im8>
		11'b11100_0_110_00 : state = 5'b00100;	//MOV Rd,Rm{,<sh_op>}
		11'b11100_0_101_xx : state = 5'b00100;	//ALU instructions
		11'b11100_0_011_00 : state = 5'b00101;	//LDR
		11'b11100_0_100_00 : state = 5'b00101;	//STR
		11'b11100_0_111_xx : state = 5'b11111;	//HALT
		//  ^^^ changed them to start taking messages from the decode state

		//state 00100 Load B
		11'b00100_0_101_0x : state = 5'b00101;	//Load A
		11'b00100_0_101_10 : state = 5'b00101;	//Load A 
		11'b00100_0_110_00 : state = 5'b00110;	//ALU
		11'b00100_0_101_11 : state = 5'b00110;	//ALU

		//state 00001 writeImm
		11'b00001_0_xxx_xx : state = 5'b01000; 	//IF1
		
		//state 00101 Load A
		11'b00101_0_xxx_xx : state = 5'b00110;	//always goes to ALU
		
		//state 00110 ALU operations
		11'b00110_0_101_01 : state = 5'b01000;	//CMP - IF1
		11'b00110_0_110_00 : state = 5'b00111;	//IF1
		11'b00110_0_101_00 : state = 5'b00111;	//IF1
		11'b00110_0_101_1x : state = 5'b00111;	//IF1
		11'b00110_0_011_00 : state = 5'b01100;	//LDR - ReadMem
		11'b00110_0_100_00 : state = 5'b01101;	//STR - SetARD
		
		//state 00111 writeReg
		11'b00111_0_xxx_xx : state = 5'b01000;
		
		//state 01100 readMem (LDR)
		11'b01100_0_xxx_xx : state = 5'b01001;	//always goes to writeMD
		
		//state 01001 readMem2 (LDR)
		11'b01001_0_xxx_xx : state = 5'b01010;
		
		//state 01010 WriteMD (LDR)
		11'b01010_0_xxx_xx : state = 5'b01000;	//always goes to IF1
		
		//state 01101 SetADR (STR)
		11'b01101_0_xxx_xx : state = 5'b01110;	//always goes to LoadBR
		
		//state 01110 LoadBR (STR)
		11'b01110_0_xxx_xx : state = 5'b01111;	//always goes to ALU2
		
		//state 01111 ALU2 (STR)
		11'b01111_0_xxx_xx : state = 5'b01011;	//always goes to Mwrite
		
		//state 01011 Mwrite (STR)
		11'b01011_0_xxx_xx : state = 5'b01000;	//always goes to IF1

		//state 11111 HALT
		11'b11111_0_xxx_xx : state = 5'b11111;
		
		default : state = 5'bxxxxx;
	endcase
	
	case (state)

		//wait
		5'b00000 : begin 
		out = 12'b000_00000000_0;
			//w = 2'b01;
		reset_pc = 1;
		load_pc  = 1;
		end
		
		//IF1
		5'b01000 : begin
		out = 12'b000_00000000_0;
		reset_pc = 0;
		load_pc = 0;
		addr_sel = 1;
		mem_cmd = `MREAD;
		end
		
		//IF2
		5'b10000 : begin
		addr_sel = 1;
		mem_cmd = `MREAD;
		load_ir = 1;
		end

		//Update PC
		5'b11000 : begin
		mem_cmd = 2'b0;
		load_ir = 0;
		load_pc = 1;
		end

		//Decode
		5'b11100 : begin
			load_pc = 0;
			out = 12'b0000000_11_000;	//defaults selects to 1
		end
		
		//writeImm
		5'b00001 : begin
			out = 12'b001_0000_10_00_1;
		end
		
		//loadB
		5'b00100 : begin
			out = {(7'b100_0010), 2'b01, (3'b0)};
		end
		
		//loadA
		5'b00101 : out = {(7'b001_0001),out[4], 1'b0, (3'b0)};
		
		//ALU instructions
		5'b00110 : out = {3'b000_,({opcode,op}==5'b10101 ? 1 : 0),1'b1,op,out[4],out[3],3'b00_0};
	
		//writeReg
		5'b00111 : out = 12'b010_00000000_1;
		
		//readMem
		5'b01100: begin
		load_addr = 1; addr_sel = 0; mem_cmd = `MREAD;
		end
		
		//readMem2
		5'b01001 : begin
		end
		
		//writeMD
		5'b01010 : begin
		out = 12'b010_000011001;
		end
		
		//SetADR
		5'b01101 : begin
		load_addr = 1; addr_sel = 0;
		end
		
		//LoadBR
		5'b01110 : begin
		out = {(7'b010_0010), 2'b01, (3'b0)};
		end
		
		//ALU2
		5'b01111 : begin
		out = {5'b000_01,op,out[4],out[3],3'b00_0};
		end
		
		//Mwrite
		5'b01011 : begin
		mem_cmd = `MWRITE;
		end
		
		//HALT
		5'b11111 : begin
		end
		
		default : out = 12'b000000000000;
		
			
		
	endcase
	
	
end

endmodule







