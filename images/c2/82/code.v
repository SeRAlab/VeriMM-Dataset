module falling_edge_detector (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 0;
        out <= 0;
    end else begin
        shift_reg <= {shift_reg[30:0], in};
        out <= out & ~shift_reg;
    end
end

endmodule