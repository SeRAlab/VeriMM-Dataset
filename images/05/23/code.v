module four_bit_adder (
    input [3:0] A,
    input [3:0] B,
    input enable,
    output reg [3:0] sum,
    output reg carry_out
);
    always @(*) begin
        if (enable) begin
            {carry_out, sum} = A + B; // Perform addition
        end else begin
            sum = 4'b0000; // Output zero when not enabled
            carry_out = 1'b0;
        end
    end
endmodule