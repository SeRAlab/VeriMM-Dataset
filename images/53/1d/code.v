module top_module(
    // Inputs
    input rst,
    input en,
    input [3:0] A,
    input [3:0] B,
    // Outputs
    output [4:0] S
);reg [4:0] S_reg;

always @(*) begin
    if (rst) begin
        S_reg <= 5'b0;
    end else if (en) begin
        S_reg <= {1'b0, A} + {1'b0, B};
    end
end

assign S = S_reg;

endmodule