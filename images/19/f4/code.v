module fixed_point_adder (
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] sum
);
    wire signed [8:0] temp_sum;
    
    assign temp_sum = a + b;

    always @* begin
        if (temp_sum > 8'sb01111111) // maximum value for 8-bit 2's complement
            sum = 8'sb01111111; // saturate to max
        else if (temp_sum < 8'sb10000000) // minimum value for 8-bit 2's complement
            sum = 8'sb10000000; // saturate to min
        else
            sum = temp_sum[7:0]; // no overflow, take the lower 8 bits
    end
endmodule