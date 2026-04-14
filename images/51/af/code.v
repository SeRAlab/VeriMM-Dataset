module top_module(
    input clk,
    input din,
    output dout,
    input reset_n
);// Replacing wasca_altpll_1_dffpipe_l2c with a standard D flip-flop design.
reg wire_dffpipe3_q;

// D flip-flop implementation
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        wire_dffpipe3_q <= 1'b0; // Reset to 0 on reset
    else
        wire_dffpipe3_q <= din; // Capture input data
end

assign dout = wire_dffpipe3_q;

endmodule