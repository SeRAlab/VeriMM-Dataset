module top_module(input signed [7:0] A, input signed [7:0] B, output reg signed [7:0] sum, output reg C);always @(*) begin
        sum = A + B;
        if (sum > 127 || sum < -128)
            C = 1;
        else
            C = 0;
    end

endmodule