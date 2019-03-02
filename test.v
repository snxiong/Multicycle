module test
(
	input e, s0, s1, s2, done
);

	always@(*)
		begin
		$display("TEST#1 e = %b | s0 = %b | s1 = %b | s2 = %b | done = %b",e, s0, s1, s2, done);
	end
		

endmodule
