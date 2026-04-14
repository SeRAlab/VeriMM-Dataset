module top_module(
    input [3:0] a,
    input [3:0] b,
    input sub,
    output reg [3:0] sum,
    output overflow
);reg [4:0] temp_sum;
    reg temp_overflow;

    always @(*) begin
        if (sub == 1) begin
            temp_sum <= a - b;
            temp_overflow <= (temp_sum < 0);
        end
        else begin
            temp_sum <= a + b;
            temp_overflow <= (temp_sum > 15);
        end
    end

    assign sum = temp_sum[3:0];
    assign overflow = temp_overflow;

endmodule