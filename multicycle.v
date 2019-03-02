// Steven Xiong
// CSC 142
// Project#2
module controlUnitFSM
(
	input start, mode, clock, reset,
	output reg e, s0, s1, s2, done
);
	parameter	A = 2'b00,
			B = 2'b01,
			C = 2'b10,
			D = 2'b11;

	reg [1:0] current_state = A; // current_state will hold a 2-bit value
	reg [1:0] next_state;	// next_state will also hold a 2-bit value	
	
	initial begin
		done = 0;
	end	

	// Section 1 Next State Generator (NSG)	////////////////////
	always@(*)
	 begin
	if(done == 0) begin
	
		casex(current_state)
		A:if(start == 1) begin
			next_state = B; end
		else  begin
			next_state = A;end
		B:	begin
			next_state = C; end
		C: 	begin
			next_state = D; end
		D: 	begin
			next_state = A; end
			// nothing	
		endcase
	
		end 	 // end of if(start == 1) statement
	end
	/////////////////	END OF NSG	//////////////////

	// Section 2 Output Generator (OG)	//////////////////
	always@(*)
	 begin
	//if(done == 0)begin
		//$display("=======================Output Generator OG==================");
		//$display("Time = %g OG current_state = %d",$time,  current_state);
		if(current_state == A && done == 0) begin
			e = 0; s0 = 1'bx; s1 = 1'bx; s2 = 1'bx; done = 0; end//  $display("OG point#A\n"); end
		else if(current_state == B && done == 0) begin
			e = 1; s0 = 0; s1 = 1'bx; s2 = 1'bx; done = 0;  end//$display("OG point#B\n"); end
		else if(current_state == C && done == 0) begin
			e = 1; s0 = 1; s1 = 0; s2 = 0; done = 0; end// $display("OG point#C\n"); end
		else if(current_state == D && mode == 0 && done == 0) begin
			e = 1; s0 = 1; s1 = 1; s2 = 0; done = 1; end  //$display("OG point#D1\n"); end
		else if(current_state == D && mode == 1 && done == 0) begin
			e = 1; s0 = 1; s1 = 0; s2 = 1; done = 1; end// $display("OG point#D2\n"); end
		
		//$display("e = %b, s0 = %b, s1 = %b, s2 = %b, done = %b\n\n", e, s0, s1, s2, done);
	//	end	// end of if(done == 0) statement
	end
	/////////////////	END OF OG	/////////////////////

	// Section 3 Flip-Flop	/////////////////////////////////////
	//always@(*)
	always@(*)
	begin
		//$display("FLIP FLOP DATA\n e = %b | s0 = %b | s1 = %b | s2 = %b | done = %b", e, s0, s1, s2, done);
		if(reset == 1) begin
			current_state <= A;
		 end
		else begin
			current_state <= next_state;
		 end
	end
	/////////////////	END OF FLIP-FLOP	//////////////////	
	 

endmodule

