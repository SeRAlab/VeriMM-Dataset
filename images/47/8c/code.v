module top_module(
    input [3:0] A,
    input [3:0] B,
    input sub,
    output reg [3:0] result
);always @(*) begin
        if (sub) begin
            result <= A - B;
        end else begin
            result <= A + B;
        end
    end

endmodule