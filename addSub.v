// Steven Xiong
// CSC 142
// Project #2

module addSub
(
	input [7:0] A, B, C, D,
	input clock, reset, done, 
	input s0, s1, s2, addOrSub,
	output reg [7:0] addSubInput
);
/*
	always@(*)
	begin
		$display("A = %d, B = %d, C = %d, D = %d", A, B, C, D);
	end

	always@(s0 or s1 or s2)
	begin
		$display("addSub %b | %b | %b | %b | %b", s0, s1, s2,done,  addOrSub);
	end
*/
/*
	always@(*)
	begin
		$display("addsub %b | %b | %b | %b", s0, s1, s2, addOrSub);
	end		
*/
	wire [7:0] muxData, registerResult, addSubOutput;
	

	mux2to1 mux2to1_mod(A, addSubOutput, s0, registerResult);		
	mux3to1 mux3to1_mod(B, C, D, s1, s2,e, muxData);	// outputs muxData


	BigAdderMod bigAddSub_mod(muxData, addSubInput, addOrSub, done, s1, s2, addSubOutput);
/*
	always@(addSubOutput)
	begin
		$display("addSubOutput = %d ", addSubOutput);
	end
*/
	
	// FLIP FLOP
	always@(registerResult)
	begin
		if(reset == 1)
			addSubInput <=0;
		else
			addSubInput <= registerResult;
		//$display("addSubInput = %d, addSubInput = %d",addSubInput ,registerResult);
	end
	

endmodule

/******************************************************************************************/
//				Adder Subtraceter
/******************************************************************************************/


module BigAdderMod(muxData, addSubInput, addOrSub, done,s1, s2,  addSubOutput);	
	input [7:0] muxData, addSubInput;
	input addOrSub, done, clock, s1, s2;
	output reg [7:0] addSubOutput;
	
	reg [8:0] sumRegister;	
	
	always@(s1 or s2 or muxData)
	begin
//		$display("muxData = %d, addSubInput = %d", muxData, addSubInput);
		if(done == 0)
		begin
			if(addOrSub == 1) begin
				sumRegister = addSubInput + muxData;
				$display("%d + %d = %d", addSubInput, muxData, sumRegister);			
			end
		
			else if(addOrSub == 0) begin
				sumRegister = addSubInput - muxData;
				$display("%d - %d = %d", addSubInput, muxData, sumRegister);
			end

			
		end

		if(sumRegister[8] == 1) begin
			addSubOutput = {sumRegister[7:0]};
		end
		
		else begin
			addSubOutput = sumRegister;
		end
			
	end	
		

endmodule


/******************************************************************************************/

module mux3to1(B, C, D, s1, s2,e, muxData);	// 8-bit 3-to-1 MUX module that decides to output B, C, or D

	input [7:0] B, C, D;
	input  s1, s2, e;	// control signals
	output reg [7:0] muxData; // output

	always@(s1 or s2)
	begin
//		$display("mux s1 = %b | s2 = %b", s1, s2);
		if(s2 == 0 && s1 == 0)	// if the control signal == 0, then the MUX outputs 'B'
			muxData = B;
		else if(s2 == 0 && s1 == 1)	// if the control signal == 1, then the MUX outputs 'C'
			muxData = C;
		else if(s2 == 1 && s1 == 0)	// if the control signal == 2, then the MUX outputs 'D'
			muxData = D;

//		$display("mux2Data = %d", muxData);
			// do nothing
	end	

endmodule


module mux2to1(A, addSubOutput, s0,registerResult);
	input [7:0] A, addSubOutput;
	input s0;
	output reg [7:0] registerResult;

	always@(s0 or addSubOutput)
	begin
		//$display("mux2to1 s0 = %b, addSubOutput = %d", s0, addSubOutput);
		if(s0 == 0)
			registerResult = A;
		else
			registerResult = addSubOutput;

		//$display("mux2 registerResult = %d", registerResult);
	end
endmodule

/*
module registerMod(registerResult, reset, addSubInput);

	input [7:0] registerResult;		// incoming results to be stored in flip flips
	input reset;
	output [7:0] addSubInput;
	reg [7:0] addSubInput;
	always@(registerResult or reset)
	 begin
		//registerResult = 8'h00;
		
		if(reset == 1) begin
			addSubInput <= 8'h00;
		end
		else begin
			addSubInput <= registerResult;
		end
	
	end	

endmodule

*/
