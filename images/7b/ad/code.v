module top_module(
    input [7:0] a,
    input [7:0] b,
    input op,
    output reg [7:0] result
    );always @(*) begin
        if (op == 0) begin
            result = a + b;
        end else begin
            result = a - b;
        end
    end

endmodule