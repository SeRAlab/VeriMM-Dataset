module top_module(
    input [15:0] a,
    input [15:0] b,
    output reg [15:0] sub,
    output reg carry,
    output reg overflow
);always @(*) begin
        // Perform subtraction using 2's complement arithmetic
        sub = a - b;
        carry = (a < b); // Set carry output to 1 if a < b
        overflow = (sub[15] != a[15] && sub[15] != b[15]); // Set overflow output to 1 if result is outside the range of signed 16-bit integers
        
        // Adjust result if a < b
        if (a < b) begin
            sub = sub + 65536; // Add 2^16 to result
        end
    end
    
endmodule