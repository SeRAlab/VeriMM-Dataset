module top_module(
    input [3:0] A,
    input [3:0] B,
    input shift_left,
    input shift_right,
    output reg [3:0] result
);always @(*) begin
        if (shift_left) begin
            result = A << B;
        end
        else if (shift_right) begin
            result = A >> B;
        end
        else begin
            result = A;
        end
    end

endmodule