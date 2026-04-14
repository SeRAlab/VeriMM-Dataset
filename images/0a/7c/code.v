module fixed_point_adder (
    input [7:0] a, // 8-bit fixed-point input a
    input [7:0] b, // 8-bit fixed-point input b
    output reg [7:0] sum // 8-bit fixed-point output sum
);
    always @(*) begin
        // Perform addition
        sum = a + b;

        // Saturation logic
        if (sum > 8'b01111111) // maximum value for 4.4 fixed-point
            sum = 8'b01111111; // saturate to maximum
    end
endmodule