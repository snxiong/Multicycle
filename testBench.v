// Steven Xiong
// CSC142
// project#2
`include "multicycle.v"
`include "addSub.v"

module testBench();

	reg [7:0] A, B, C, D;
	reg start, mode, clock, reset;
	wire e, s0, s1, s2, done, addOrSub;

	wire [7:0] addSubInput;
	//tester testerMod(start, mode, clock, reset, A, B, C, D);	

	controlUnitFSM controlUnit_mod(start, mode, clock ,reset, e, s0, s1, s2, done, addOrSub);		
	addSub addSub_mod(A, B, C, D, clock, reset, done, s0, s1, s2, addOrSub, addSubInput);

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
		#10 start = 1; mode = 0; A = 8'h01; B = 8'h02; C = 8'hFF; D = 8'h02;
		#20 start = 0; mode = 1'bx;
		$display("=======================");
		#10 reset = 1;
		#10 start = 1; mode = 1; reset = 0; A = 8'hFE; B = 8'h01; C = 8'h01; D = 8'h04;
		#20 start = 0; mode = 1'bx;	
		$display("=======================");
		#10 reset = 1;
		#10 start = 1; mode = 0; reset = 0; A = 8'h01; B = 8'hFF; C = 8'hFF; D = 8'h02;
		#20 start = 0; mode = 1'bx;
		$display("=======================");
		#10 reset = 1;
		#10 start = 1; mode = 1; reset = 0; A = 8'hFE; B = 8'h02; C = 8'hFF; D = 8'h02;
		#20 start = 0; mode = 1'bx;		
		#10 $finish;
	end

endmodule
/*
module tester
(
	input start, mode, clock, reset,
	input [7:0] A, B, C, D
);

	always@(start) begin
		$display(" %b | %b | %b |, A = %d, B = %d, C = %d, D = %d", start, mode, reset, A, B, C, D);
	end

endmodule */
