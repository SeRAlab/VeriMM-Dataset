module top_module(clk, reset, sig, posedgesig_f, negedgesig_f
    );input clk, sig, reset;
	 output posedgesig_f, negedgesig_f;
	 
	 reg sig_d;
	 
	 
	 always @ (posedge clk or negedge reset) 
	 
	 if (!reset) begin
		sig_d = 0;
	 end else begin
		sig_d = sig;
	 end 
	 
	 assign posedgesig_f = sig & !sig_d;
	 assign negedgesig_f = !sig & sig_d;

endmodule