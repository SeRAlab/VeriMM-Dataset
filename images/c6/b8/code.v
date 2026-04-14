module adder (
    input [7:0] a,
    input [7:0] b,
    output [8:0] c
);

    wire [8:0] sum;
    wire carry;

    always @(a, b) begin
        sum = a + b;
        carry = (sum[8] == 1);
    end

    assign c = {carry, sum[7:0]};

endmodule