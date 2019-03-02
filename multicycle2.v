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

	NSG nsg_mod(current_state, start, A, B, C, D, next_state);
//	OG og_mod(current_state, A, B, C, D, e, s0, s1, s2, done);
//	FF ff_mod(clock, reset, next_state, current_state);	

endmodule
/*
module FF(
	input clock, reset, 
	input [1:0] next_state,
	output [1:0] current_state
);
	always@(posedge clock or negedge reset)
	begin
		if(reset) begin
			current_state <= 2'b00; end
		else begin
			current_state <= next_state; end
	end

endmodule

module OG(
	input [1:0] current_state, A, B, C, D,
	output e, s0, s1, s2, done
);
	always@(*)
	begin
		if(current_state == A) begin
			e = 0; s0 = 1'bx; s1 = 1'bx; s2 = 1'bx; done = 0; end
		else if(current_state == B) begin
			e = 1; s0 = 0; s1 = 1'bx; s2 = 1'bx; done = 0; end
		else if(current_state == C) begin
			e = 1; s0 = 1; s1 = 0; s2 = 0; done = 0; end
		else if(current_state == D && mode == 0) begin
			e = 1; s0 = 1; s1 = 1; s2 = 0; done = 1; end
		else if(current_state == D && mode == 1) begin
			e = 1; s0 = 1; s1 = 0; s2 = 1; done = 1; end
	end

endmodule
*/
module NSG(current_state, start,A, B, C, D, next_state);
	input [1:0] current_state, A, B, C, D;
	input start;
	wire [1:0] next_state;
	

	always@(*)
	begin
		casex(current_state)
		A:if(start == 1) begin
			next_state = B; end
		else begin
			next_state = A; end 
		B: begin
			next_state = C; end
		C: begin
			next_state = D; end
		D: begin
			next_state = A; end
		endcase
	end

endmodule
