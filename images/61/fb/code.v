module top_module(
    input clk,
    input rst,
    input signed [3:0] a,
    input signed [3:0] b,
    output signed [3:0] sum,
    output carry_out
);reg signed [3:0] temp_sum;
    reg carry;

    always @ (posedge clk or negedge rst) begin
        if (~rst) begin
            temp_sum <= 4'b0;
            carry <= 1'b0;
        end
        else begin
            temp_sum <= a + b + carry;
            carry <= (temp_sum[4] == 1);
        end
    end

    assign sum = temp_sum;
    assign carry_out = carry;

endmodule