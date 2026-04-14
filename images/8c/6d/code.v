module top_module(
    // inputs
    input in,
    input shift,
    input clk,
    input reset,
    // outputs
    output reg [3:0] out
);always @(posedge clk or negedge reset) begin
    if (reset == 0) begin
        out <= 4'b0;
    end else if (shift == 1) begin
        out <= {out[2:0], in};
    end
end

endmodule