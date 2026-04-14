module top_module(
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    input clk,
    input reset,
    input enable,
    output reg q
);reg [2:0] shift_reg;
wire mux_output;

// 2-to-1 multiplexer
assign mux_output = (sel_b1) ? b : ((sel_b2) ? a : (a & b));

// Shift register
always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 3'b0;
    end else if (enable) begin
        shift_reg <= {mux_output, shift_reg[2:1]};
    end
end

// Output
assign q = shift_reg[0];

endmodule