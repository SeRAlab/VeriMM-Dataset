module vector_adder (
    input [3:0] a,        // 4-bit input vector a
    input [3:0] b,        // 4-bit input vector b
    input enable,         // enable signal
    output reg [3:0] sum, // 4-bit sum output
    output reg carry_out   // carry out output
);
    always @(*) begin
        if (enable) begin
            {carry_out, sum} = a + b; // Perform addition
        end else begin
            sum = 4'b0000;   // If not enabled, output zero
            carry_out = 1'b0; // No carry out
        end
    end
endmodule