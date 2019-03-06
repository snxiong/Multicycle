// Steven Xiong
// CSC142
// project#2
`include "multicycle.v"
`include "addSub.v"

module testBench();

	reg signed [7:0] A, B, C, D;
	reg start, mode, clock, reset;
	wire  s0, s1, s2, done, addOrSub;

	wire signed [7:0] addSubInput;
	//tester testerMod(start, mode, clock, reset, A, B, C, D);	

	controlUnitFSM controlUnit_mod(start, mode, clock ,reset, s0, s1, s2, done, addOrSub);		
	addSub addSub_mod(A, B, C, D, clock, reset, done, s0, s1, s2, addOrSub, addSubInput);

	initial begin
		
		$monitor("Result = %d\nDone = %b", addSubInput, done);
	end	

/*
	always@(*)
	begin
		$display("result = %d", addSubInput);
	end
/*
 	
	always@(*)
	begin
		$display(" %b | %b | %b | %b", s0, s1, s2, addOrSub);
	end
*/
	always begin
		#5; clock = ~clock;
	end

	initial begin
		clock = 0;	
		reset = 0;
		
		// Test Case #1	
		#10 start = 1; mode = 0; A = 8'h01; B = 8'h02; C = 8'hFF; D = 8'h02;
		$display("================ A ================");
		$display("(%d) + (%d) + (%d) - (%d)", A, B, C, D);
		#20 start = 0; mode = 1'bx;
		#10 reset = 1;
		
		// Test Case #2
		#10 start = 1; mode = 1; reset = 0; A = 8'hFE; B = 8'h01; C = 8'h01; D = 8'h04;
		$display("================ B ================");
		$display("(%d) - (%d) + (%d) + (%d)", A, B, C, D);
		#20 start = 0; mode = 1'bx;	
		#10 reset = 1;

		// Test Case #3
		#10 start = 1; mode = 0; reset = 0; A = 8'h01; B = 8'hFF; C = 8'hFF; D = 8'h02;
		$display("================ C ===============");
		$display("(%d) + (%d) + (%d) - (%d)", A, B, C, D);
		#20 start = 0; mode = 1'bx;
		#10 reset = 1;

		// Test Case #4
		#10 start = 1; mode = 1; reset = 0; A = 8'hFE; B = 8'h02; C = 8'hFF; D = 8'h02;
		$display("================ D ===============");
		$display("(%d) - (%d) + (%d) + (%d)", A, B, C, D);
		#20 start = 0; mode = 1'bx;		
		#10 reset = 1;
		
		#10 $finish;
	end

endmodule

