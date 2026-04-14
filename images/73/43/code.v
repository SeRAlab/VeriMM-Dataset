module top_module(
    input [7:0] a,
    input [7:0] b,
    output reg [8:0] c  // Changed to reg to hold values in always block
);reg [8:0] sum;  // Changed to reg to enable assignment in always block
    wire carry;

    always @(a, b) begin
        sum = a + b;
        // carry does not need to be declared as a register since we can derive it directly
    end

    assign carry = sum[8];  // Assign carry based on sum
    assign c = {carry, sum[7:0]};

endmodule