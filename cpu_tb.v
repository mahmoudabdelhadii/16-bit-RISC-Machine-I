module cpu_tb;
reg clk,reset;
reg [15:0] read_data;
wire [15:0] write_data;
wire HALTLED;
reg err;
wire [8:0] mem_addr;
wire [1:0] mem_cmd;


cpu DUT(.clk(clk),.reset(reset), .mem_addr(mem_addr), .mem_cmd(mem_cmd), .read_data(read_data), .write_data(write_data),.HALTLED(HALTLED));
//(clk,reset, mem_addr, mem_cmd, read_data, write_data,HALTLED);

	//define my_checker task
	task my_checker;    
		//checker inputs
		input [15:0] expected_out; //the expected output of CPU
		input [2:0] expected_Z; //the expected status of CPU
	begin
		//test dut output
		if( cpu_tb.DUT.write_data !== expected_out ) begin
			$display("ERROR ** output is %b, expected %b", cpu_tb.DUT.write_data, expected_out  );
			err = 1'b1;
		end
		//test dut Status output
		if( cpu_tb.DUT.Z !== expected_Z ) begin
			$display("ERROR ** status is %b, expected %b", cpu_tb.DUT.Z, expected_Z );
			err = 1'b1;
		end
	end
	endtask


  initial begin
    clk = 0; #5;
    forever begin
      clk = 1; #5;
      clk = 0; #5;
    end
  end

initial begin
	//Add
	reset = 1'b1;
	#10;
	reset = 1'b0;
	
	#10;
	
	read_data = 16'b101_00_000_100_00_001;
	#40;
	@posedge(clk);
	#40;
	
	#40;
	//Moving the number 1 to register 0 (R0)
	end
	read_data = 16'b110_10_000_00000001;
	
	#10;
	

	#10;
	
	#40;
	
	//Moving number -7 to register 1 (R1)
	read_data = 16'b110_10_001_11111001;
	
	#10;
	
	
	#10;
	
	#40;

	//Moving the number 5 to register 2 (R2)
	read_data = 16'b110_10_010_00000101;
	
	#10;
	
	
	#10;
	
	#40;
	
	//Adding both R0 and R1 (Should be -6) and storing it in R3
	read_data = 16'b101_00_000_011_00_001;
	
	#10;
	
	
	#10;
	
	#40;

	//Adding both R0 and R2 (Should be 6) and storing it in R4
	read_data = 16'b101_00_000_100_00_010;
	
	#10;
	
	
	#10;
	
	#40;

	//Adding both R1 (-7) and R2 (10) (Should be 3) and storing it in R5 use shifter
	read_data = 16'b101_00_001_101_01_010; //shifted left 1 bit 101 (5) becomes 1010 (10)
	
	#10;
	
	
	#10;
	
	#40;
	
	//Moving number (3 becomes 1 after shifting) (R5) to register R1(-7) (with right shifting)
	read_data = 16'b110_00_000_001_10_101;
	
	#10;
	
	
	#10;
	
	#40;

	//Moving number 3 (R5) to register R0(1) (without shifting)
	read_data = 16'b110_00_000_000_00_101;
	
	#10;
	
	
	#10;
	
	#40;

	//Moving number -6 (R3) to register R6(empty) (without shifting)
	read_data = 16'b110_00_000_110_00_011;
	
	#10;
	
	#10;
	
	#40;
	
	//At this point R0 (3), R1 (1), R2 (5), R3 (-6), R4 (6), R5 (3), R6 (-6), R7()

	//Anding registers R0 (3) and R1 (1) into R7 (1)
	read_data = 16'b101_10_001_111_00_000;
	
	#10;
	
	#10;
	
	#40;

	//At this point R0 (3), R1 (1), R2 (5), R3 (-6), R4 (6), R5 (3), R6 (-6), R7(1)

	//Anding registers R3 (-6) and R4 (6) into R6 (4) with shift to the left
	read_data = 16'b101_10_100_110_01_011;
	
	#10;
	
	#10;
	
	#40;

	//At this point R0 (3), R1 (1), R2 (5), R3 (-6), R4 (6), R5 (3), R6 (4), R7(1)

	//Anding registers R6 (4) and R7 (1) into R6 (4)
	read_data = 16'b101_10_110_110_00_111;
	
	#10;
	
	
	#10;
	
	#40;
	
	//At this point R0 (3), R1 (1), R2 (5), R3 (-6), R4 (6), R5 (3), R6 (0), R7(1)
	
	//test zero variable
	read_data = 16'b101_01_000_000_00_101;
	
	#10;
	
	
	#10;
	
	#40;

	//test negative variable
	read_data = 16'b101_01_011_000_00_100;
	
	#10;
	
	
	#10;
	
	#40;
	
	

	//test overflow
	read_data = 16'b101_01_000_000_00_001;
	
	#10;
	
	
	#10;
	
	#40;
	
	//test negative variable
	read_data = 16'b101_11_000_111_00_110;
	
	#10;
	
	#10;
	
	#40;

	//test negative variable
	read_data = 16'b101_11_000_110_00_101;
	
	#10;
	
	#10;
	
	#40;

	//test negative variable
	read_data = 16'b101_11_000_100_00_011;
	
	#10;
	
	#10;
	
	#40;

$stop;
end



endmodule 