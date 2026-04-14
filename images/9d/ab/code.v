module top_module(
    input [3:0] A,
    input [3:0] B,
    input op,
    output reg [3:0] result
);always @(*) begin
        if (op == 1'b0) begin
            // subtraction
            result = A - B;
        end else begin
            // addition
            result = A + B;
        end
    end
endmodule