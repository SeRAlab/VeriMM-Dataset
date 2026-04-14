module top_module(
    input clk,
    input rst,
    input [7:0] A,
    input [7:0] B,
    input [1:0] op,
    output reg [7:0] result
);always @(posedge clk) begin
    if (rst) begin
        result <= 0;
    end else begin
        case (op)
            2'b00: result <= A + B;
            2'b01: result <= A - B;
            2'b10: result <= A * B;
            2'b11: result <= A / B;
        endcase
    end
end

endmodule