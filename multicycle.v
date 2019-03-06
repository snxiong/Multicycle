// Steven Xiong
// CSC 142
// Project#2

module controlUnitFSM
(
	input start, mode, clock, reset,
	output reg e, s0, s1, s2, done, addOrSub
);
	parameter	W = 2'b00,
			X = 2'b01,
			Y = 2'b10,
			Z = 2'b11;
	
	reg cycleflag;
	//reg firstStep;

	reg [1:0] current_state; // current_state will hold a 2-bit value
	reg [1:0] next_state;	// next_state will also hold a 2-bit value	
	
	always@(start)begin
		done = 0;
		cycleflag = 0;
		current_state = W;
	//	firstStep = 0;
	end	
	
/*
	always@(posedge clock) begin
		$display("start = %b | mode = %b | reset = %b | clock = %b", start, mode, reset, clock);
	end
*/	

	// Section 1 Next State Generator (NSG)	////////////////////
	always@(*)
	begin
		if(done == 0) begin
	
			casex(current_state)
			W:if(start == 1 && cycleflag == 1) begin
				next_state = X; end
			else  begin
				next_state = W; end
			X:	begin
				next_state = Y; end
			Y: 	begin
				next_state = Z; end
			Z: 	begin
				next_state = W; end
				// nothing	
			endcase
		//	$display("NSG current_state = %b", current_state);	
	//		$display("start = %b | mode = %b | reset = %b", start, mode, reset);
		
		end 	 // end of if(start == 1) statement
	end
	/////////////////	END OF NSG	//////////////////

	// Section 2 Output Generator (OG)	//////////////////
	always@(posedge clock or current_state or cycleflag)
	begin
	
//	$display("done = %b", done);
	if(done == 0) begin
	//	$display("start =  %b | mode = %b | reset = %b | current_state = %b", start, mode, reset, current_state);
			
		if(mode == 0) begin
//			$display("point#1");
					
			if(current_state == W && cycleflag == 0) begin // start = 1, send signal of A
				cycleflag = 1; s0 = 0; s1 = 1'bx; s2 = 1'bx; done = 0; addOrSub = 1;end 
			//  $display("point#W");end
		
			else if(current_state == X) begin // send control signal to mux to output B
				s0 = 1; s1 = 0; s2 = 0; done = 0;  addOrSub = 1; end 
			//	$display("point#X");end
	
			else if(current_state == Y) begin // send control signal to mux to output C
				s0 = 1; s1 = 1; s2 = 0; done = 0; addOrSub = 1; end
			//	$display("point#Y");end
	
			else if(current_state == Z) begin
				s0 = 1; s1 = 0; s2 = 1; done = 0; cycleflag = 1; addOrSub = 0; end
			//	$display("point#Z");end
	
			else if(current_state == W && cycleflag == 1) begin
				 done = 1; end // $display("endpoint"); end
		
		end

		else if(mode == 1) begin
			
			if(current_state == W && cycleflag == 0) begin
				cycleflag = 1; s0 = 0; s1 = 1'bx; s2 = 1'bx; done = 0; addOrSub = 1; end
		
			else if(current_state == X) begin
				s0 = 1; s1 = 0; s2 = 0; done = 0; addOrSub = 0; end

			else if(current_state == Y) begin
				s0 = 1; s1 = 1; s2 = 0; done = 0; addOrSub = 1; end

			else if(current_state == Z) begin
				s0 = 1; s1 = 0; s2 = 1; done = 0; cycleflag = 1; addOrSub = 1; end
			
			else if(current_state == W && cycleflag == 1) begin
				done = 1; end
				
 
		end			
//		$display("multi  %b | %b | %b | %b | %b", s0, s1, s2, done, addOrSub);
		
	end
	end
	/////////////////	END OF OG	/////////////////////

	// Section 3 Flip-Flop	/////////////////////////////////////
	always@(*)
	begin
//		$display("FF next_state = %b", next_state);	
		if(reset == 1) begin
			current_state <= W;
		 end
		else begin
			current_state <= next_state;
		 end

//		$display("FF current_state = %b", current_state);
	end
	/////////////////	END OF FLIP-FLOP	//////////////////	
	
		
endmodule

