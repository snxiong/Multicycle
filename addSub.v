// Steven Xiong
// CSC 142
// Project #2
`include "multicycle.v"

module addSub();
	reg [7:0] A = 8'h03;
	reg [7:0] B = 8'h01;
	reg [7:0] C = 8'h05;
	reg [7:0] D = 8'h04;
	wire [7:0] muxData, addSubInput, registerResult, result, addSubOutput, resultOutput;
	
	//reg mode = 1'h1;
	
	reg clock, reset, start, mode;
	wire s0, s1, s2, done;

	always
	begin
		#5 clock = ~clock;
	end
	
	controlUnitFSM controlUnit_mod(start, mode, clock, reset, e, s0, s1, s2, done); // output e, s0, s1, s2, done
	mux3to1 mux3to1_mod(B, C, D, s1, s2, muxData);	// outputs muxData
	mux2to1 mux2to1_mod(A, addSubOutput, s0, registerResult); // output result
	registerMod reg_mod(registerResult, reset, addSubInput); // output addSubInput
	BigAdderMod BigAddSub_mod(muxData, addSubInput, mode, done, addSubOutput, resultOutput); // output addSubOutput, resultOutput

/*	
	always@(*)
	begin
		$display("addsub ==================\ne = %b | s0 = %b | s1 = %b | done = %b|\n", e, s0, s1, s2, done);	
	end
*/
	/*	
	always@(*)
	begin
		$display("mux3to1 output is %d", muxData);
	end	

	initial begin
		$monitor("resultOutput = %d", resultOutput);
	end
	*/

	initial begin
		#10 start = 1; mode = 0; reset = 0;
		#10 $finish;	
	end	


endmodule

/******************************************************************************************/
//				Adder Subtraceter
/******************************************************************************************/

module MajorityMod(muxBit, registerBit, Cfirst, Csecond);
	input muxBit, registerBit, Cfirst;
	output Csecond;
	
	wire and0, and1, and2;

	and(and0, muxBit, registerBit);
	and(and1, muxBit, Cfirst);
	and(and2, Cfirst, registerBit);
	
	or(Csecond, and0, and1, and2);	
endmodule

module ParityMod(muxBit, registerBit, Cfirst, resultBit);
	input muxBit, registerBit, Cfirst;
	output resultBit;
	
	wire wireXor;

	xor(wireXor, muxBit, registerBit);
	xor(resultBit, wireXor, Cfirst);
endmodule

module FullAddSubMod(muxBit, registerBit, Cfirst, Csecond, resultBit);
	input muxBit, registerBit, Cfirst;
	output Csecond, resultBit;

	ParityMod my_parity(muxBit, registerBit, Cfirst, resultBit);
	MajorityMod my_majority(muxBit, registerBit, Cfirst, Csecond);	

endmodule

module BigAdderMod(muxData, addSubInput, mode, done, addSubOutput, resultOutput);	
	input [7:0] muxData, addSubInput; // muxInput holds a 8-bit value from the mux3to1 module, 
					     // registerInput holds a 8-bit
					     // value from a register
	input mode;	// mode to figure out whether to add or subtractn
	wire [8:0] C;	// wire ore reg, decide later if not working
	output [7:0] resultOutput, addSubOutput;
	reg [7:0] resultOutput;

	or(C[0], mode, 0);
	
	wire [7:0] xorWire;
	input done;
	
	always@(*)
	begin
		if(done == 1) begin
			resultOutput = addSubInput;
		end
	end

/*
	always@(*)
	begin
		$display("muxData = %d & addSubInput = %d, mode = %b", muxData, addSubInput, mode);	
	end
*/	

	xor(xorWire[0], C[0], addSubInput[0]);
	xor(xorWire[1], C[0], addSubInput[1]);
	xor(xorWire[2], C[0], addSubInput[2]);
	xor(xorWire[3], C[0], addSubInput[3]);
	xor(xorWire[4], C[0], addSubInput[4]);
	xor(xorWire[5], C[0], addSubInput[5]);
	xor(xorWire[6], C[0], addSubInput[6]);
	xor(xorWire[7], C[0], addSubInput[7]);

	FullAddSubMod my_fullAddSub0(muxData[0], xorWire[0], C[0], C[1], addSubOutput[0]);
	FullAddSubMod my_fullAddSub1(muxData[1], xorWire[1], C[1], C[2], addSubOutput[1]);
	FullAddSubMod my_fullAddSub2(muxData[2], xorWire[2], C[2], C[3], addSubOutput[2]);
	FullAddSubMod my_fullAddSub3(muxData[3], xorWire[3], C[3], C[4], addSubOutput[3]);
	FullAddSubMod my_fullAddSub4(muxData[4], xorWire[4], C[4], C[5], addSubOutput[4]);
	FullAddSubMod my_fullAddSub5(muxData[5], xorWire[5], C[5], C[6], addSubOutput[5]);
	FullAddSubMod my_fullAddSub6(muxData[6], xorWire[6], C[6], C[7], addSubOutput[6]);
	FullAddSubMod my_fullAddSub7(muxData[7], xorWire[7], C[7], C[8], addSubOutput[7]);

//////////////////////////////////// FLIP FLOP /////////////





	
	integer i;	

	
	always@(*) begin
	$display("=====================");
		$display("%d + %d = %d", muxData, addSubInput, addSubOutput);
		for(i = 0; i < 8; i = i + 1)
		begin
			$display("addSubOutput[%d] = %b", i, addSubOutput[i]);
		end
	end
		

endmodule

/******************************************************************************************/

module mux3to1(B, C, D, s1, s2, muxData);	// 8-bit 3-to-1 MUX module that decides to output B, C, or D

	input [7:0] B, C, D;
	input  s1, s2;	// control signals
	output [7:0] muxData; // output
	reg [7:0] muxData;

	always@(s1 or s2)
	begin
		if(s2 == 0 && s1 == 0)	// if the control signal == 0, then the MUX outputs 'B'
			muxData = B;
		else if(s2 == 0 && s1 == 1)	// if the control signal == 1, then the MUX outputs 'C'
			muxData = C;
		else if(s2 == 1 && s1 == 0)	// if the control signal == 2, then the MUX outputs 'D'
			muxData = D;

			// do nothing
	end	

endmodule
/*
module mux2to1	// 8-bit 2-to-1 MUX module that decides to output A or not
(
	input [7:0] A, addSubInput,
	input s0,	// 1-bit mux selector to let the 2-to-1 mux know to add in A or not
	output [7:0] registerResult, // output
);

	always@(s0)
	begin
		registerResult = 8'h00;
	
		if(s0 == 1)	// if the select == 1 then the 2-to-1 mux will output the value in A
			registerResult <= A;
		else	// if the select == 0 then the 2-to-1 mux will just pass incoming data through the 2-to1 mux
			registerResult <= addSubInput;
	end			// nothing

endmodule
*/

module mux2to1(A, addSubInput, s0, registerResult);
	input [7:0] A, addSubInput;
	input s0;
	output[7:0] registerResult;
	reg [7:0] registerResult;

	always@(A or addSubInput or s0)
		if(s0 == 1)
			registerResult = A;
		else
			registerResult = addSubInput;

endmodule

module registerMod(registerResult, reset, addSubInput);

	input [7:0] registerResult;		// incoming results to be stored in flip flips
	input reset;
	output [7:0] addSubInput;
	reg [7:0] addSubInput;	
/*	
	always@(*)
	begin
		$display("registerResult = %d && addSubInput = %d", registerResult, addSubInput);	
	end
*/
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


