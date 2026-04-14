module pipelined_multiplier (
    input clk,
    input rst,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] result
);

reg [7:0] a_reg;
reg [7:0] b_reg;

always @(posedge clk) begin
    if (rst) begin
        a_reg <= 8'h00;
        b_reg <= 8'h00;
        result <= 16'h0000;
    end else begin
        a_reg <= a;
        b_reg <= b;
        result <= {8'h00, a_reg} * {8'h00, b_reg};
    end
end

endmodule