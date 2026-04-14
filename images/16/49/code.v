module md5_hash(input [63:0] data, input clk, input rst, output reg [31:0] hash);  
    reg [31:0] a, b, c, d;  
    reg [63:0] temp_data;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            a <= 32'h67452301;  
            b <= 32'hEFCDAB89;  
            c <= 32'h98BADCFE;  
            d <= 32'h10325476;  
            hash <= 32'h0;  
        end else begin  
            temp_data <= data;  
            a <= a + (b ^ c ^ d) + temp_data[31:0];  
            b <= b + (a ^ c ^ d) + temp_data[63:32];  
            c <= c + (a ^ b ^ d) + temp_data[31:0];  
            d <= d + (a ^ b ^ c) + temp_data[63:32];  
            hash <= a ^ b ^ c ^ d;  
        end  
    end  
endmodule