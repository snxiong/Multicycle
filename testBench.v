// Steven Xiong
// CSC142
// project#2
`include "multicycle.v"
//`include "test.v"

module testBench();
	reg clock, reset, start, mode;
	wire e, s0, s1, s2, done;


	controlUnitFSM control_mod1(start, mode, clock, reset, e, s0, s1, s2, done);
	//test test_mod(e, s0, s1, s2, done);



/*	
	initial begin
		$monitor("========================RESULTS=================\nTime = %g | e = %b | s0 = %b | s1 = %b | s2 = %b | done = %b \n", $time,  e, s0, s1, s2, done);
		clock = 0;
		reset = 1;
		start = 0;
		mode = 0;
		#10 reset = 0;
	end
*/	

	always@(*)
	begin
		$display("=======================RESULTS==================\nTime = %g | e = %b | s0 = %b | s1 = %b | s2 = %b | done = %b \n", $time, e, s0, s1, s2, done);	
	end
	

	always
	begin
		#5; clock = ~clock;
	end

	initial begin
		#10 start = 1; mode = 0; reset = 0;
		#10 $finish;
	end


endmodule
