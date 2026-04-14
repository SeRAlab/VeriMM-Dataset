module md5_hash (  
    input wire clk,  
    input wire reset,  
    input wire [127:0] data_in,  
    output reg [31:0] hash_out  
);  
    reg [31:0] A, B, C, D;  
    reg [127:0] data;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            A <= 32'h67452301;  
            B <= 32'hefcdab89;  
            C <= 32'h98badcfe;  
            D <= 32'h10325476;  
            hash_out <= 32'h0;  
        end else begin  
            data <= data_in;  
            // A simple transformation to simulate hashing  
            A <= A + (data[31:0] ^ B) + (C << 5);  
            B <= B + (data[63:32] ^ C) + (D << 5);  
            C <= C + (data[95:64] ^ D) + (A << 5);  
            D <= D + (data[127:96] ^ A) + (B << 5);  
            hash_out <= A ^ B ^ C ^ D;  
        end  
    end  
endmodule