module top_module(
    input clk,
    input reset,            // Synchronous reset
    input [7:0] d,
    output reg [7:0] q
);reg [7:0] shift_reg;

always @(negedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;
    end else begin
        shift_reg <= {shift_reg[6:0], d};
    end
end

assign q = shift_reg;

endmodule