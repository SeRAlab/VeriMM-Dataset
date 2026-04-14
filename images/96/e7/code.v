module top_module(
    input clk,
    input trigger,
    input Interleave_b,
	 input FF_en,
	 `ifdef XILINX_ISIM
		output reg output_en = 1'b1
	 `else
		output reg output_en = 1'b0
	 `endif
    );(* shreg_extract = "no" *) reg Interleave = 1'b0, Interleave_a = 1'b0;
(* shreg_extract = "no" *) reg FF_en_a = 1'b0, FF_en_b = 1'b0;

always @(posedge clk) begin
	Interleave <= Interleave_a;
	Interleave_a <= Interleave_b;
	FF_en_a <= FF_en;
	FF_en_b <= FF_en_a;
	
	
	
	
	if (trigger && FF_en_b) output_en <= (Interleave) ? ~output_en : 1'b1;
	else if (trigger) output_en <= 1'b0;
	else output_en <= output_en;
	
	
end
	
endmodule