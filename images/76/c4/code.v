module top_module(
    input clk,
    input FONT5_detect,
	 input auxOutA,
	 input auxOutB,
    (* IOB = "TRUE" *) output reg auxOutA1,
    (* IOB = "TRUE" *) output reg auxOutB1,
    (* IOB = "TRUE" *) output reg auxOutA2,
    (* IOB = "TRUE" *) output reg auxOutB2
    );(* IOB = "TRUE" *) reg FONT5_detect_a;
reg FONT5_detect_b;
 
always @(posedge clk) begin
	FONT5_detect_a <= FONT5_detect;
	FONT5_detect_b <= FONT5_detect_a;
	auxOutA1 <= (FONT5_detect_b) ? auxOutA : 1'bz;
	auxOutB1 <= (FONT5_detect_b) ? auxOutB : 1'bz;
	auxOutA2 <= (FONT5_detect_b) ? 1'bz : ~auxOutA; 
	auxOutB2 <= (FONT5_detect_b) ? 1'bz : ~auxOutB; 
end

endmodule