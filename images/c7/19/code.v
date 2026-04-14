module adder_module(
    input clk,
    input rst,
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] R
);

always @ (posedge clk) begin
    if (rst) begin
        R <= 8'h0;
    end else begin
        R <= A + B + 1;
    end
end

endmodule