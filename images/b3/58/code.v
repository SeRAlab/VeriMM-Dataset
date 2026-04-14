module top_module(
    input [15:0] A_in,
    input [15:0] B_in,
    output reg [15:0] sum_out,
    output reg [15:0] diff_out,
    output reg [15:0] abs_diff_out,
    output reg [15:0] and_out,
    output reg [15:0] or_out,
    output reg [15:0] xor_out
);always @(*) begin
        // Sum
        sum_out = A_in + B_in;
        
        // Difference
        diff_out = A_in - B_in;
        
        // Absolute difference
        if (A_in > B_in) begin
            abs_diff_out = A_in - B_in;
        end else begin
            abs_diff_out = B_in - A_in;
        end
        
        // Bitwise AND
        and_out = A_in & B_in;
        
        // Bitwise OR
        or_out = A_in | B_in;
        
        // Bitwise XOR
        xor_out = A_in ^ B_in;
    end

endmodule