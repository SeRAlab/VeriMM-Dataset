module top_module(mux_sel,mux_in1,mux_in2,mux_out);input [15:0] mux_in1;
	input [15:0] mux_in2;
	input mux_sel;
	output [15:0] mux_out;
	reg [15:0] mux_out;

	always @(mux_sel or mux_in1 or mux_in2) begin : proc_
		if(mux_sel) begin
			 mux_out= mux_in2;
		end else begin
			 mux_out= mux_in1;
		end
	end

endmodule