module top_module(
    input clk,
    input reset,
    input [7:0] seed,
    output reg [7:0] q
);reg [99:0] shift_reg;
reg mux_sel;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= {100{1'b0}};
        mux_sel <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[98:0], mux_sel};
        mux_sel <= shift_reg[93] ^ shift_reg[91] ^ shift_reg[87] ^ shift_reg[84];
    end
end

always @(posedge clk) begin
    if (reset) begin
        q <= seed;
    end else begin
        q <= {shift_reg[99], shift_reg[95], shift_reg[91], shift_reg[87], shift_reg[83], shift_reg[79], shift_reg[75], shift_reg[71]};
    end
end

endmodule