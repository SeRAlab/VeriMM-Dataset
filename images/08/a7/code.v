module md5_hash (
    input [31:0] data_in,
    input clk,
    input reset,
    output reg [31:0] hash_out
);
    
    // Internal state
    reg [31:0] a, b, c, d;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            a <= 32'h67452301;
            b <= 32'hEFCDAB89;
            c <= 32'h98BADCFE;
            d <= 32'h10325476;
        end else begin
            // Simple hashing operation
            a <= a + (data_in ^ b);
            b <= b + (c & d);
            c <= c + (data_in | a);
            d <= d + (b ^ data_in);
        end
    end

    always @(posedge clk) begin
        hash_out <= a ^ b ^ c ^ d;
    end

endmodule