module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] S,
    output reg C_out
);wire [3:0] temp_sum;
    wire carry;

    assign temp_sum = A + B;
    assign carry = (temp_sum[4] == 1);

    always @ (A or B) begin
        S <= temp_sum[3:0];
        C_out <= carry;
    end

endmodule