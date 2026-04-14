module top_module(
    input [7:0] A,
    input [7:0] B,
    input enable,
    output reg [7:0] result
);always @ (A, B, enable) begin
        if (enable) begin
            result = A ^ B;
        end
        else begin
            result = 8'b0;
        end
    end

endmodule