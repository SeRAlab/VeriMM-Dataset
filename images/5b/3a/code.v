module top_module(
    input clk,
    input [15:0] DIN,
    input [3:0] SHIFT,
    output reg [15:0] DOUT
);always @(posedge clk) begin
    if (SHIFT >= 0) begin
        DOUT <= DIN << SHIFT;  // Left shift
    end else begin
        DOUT <= DIN >> (-SHIFT); // Right shift using negated SHIFT for unsigned value
    end
end

endmodule