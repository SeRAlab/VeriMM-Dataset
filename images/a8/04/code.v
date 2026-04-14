module top_module(
    input [3:0] in0,
    input [3:0] in1,
    input carry_in,
    output reg [3:0] sum,
    output reg carry_out
);// Define internal signals
    reg [3:0] temp_sum;
    reg temp_carry;

    // Implement the adder
    always @(*) begin
        temp_sum = in0 + in1 + carry_in;
        temp_carry = (temp_sum > 4'b1111) ? 1'b1 : 1'b0;
        sum = temp_sum;
        carry_out = temp_carry;
    end

endmodule