module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    output reg [4:0] sum
);always @ (*) begin
    sum = {1'b0, A} + {1'b0, B} + {1'b0, C} + {1'b0, D};
    if (sum > 15) begin
        sum = sum[3:0];
    end
end

endmodule