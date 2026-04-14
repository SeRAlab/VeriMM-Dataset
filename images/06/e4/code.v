module md5_hash (  
    input [127:0] data_in,  
    input clk,  
    input rst,  
    output reg [31:0] hash_out  
);  
    reg [127:0] A, B, C, D;  
    reg [31:0] F;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            A <= 128'h0123456789abcdef0123456789abcdef; // Initial hash value  
            B <= 128'hfedcba98765432100123456789abcdef;  
            C <= 128'h89abcdef0123456789abcdef01234567;  
            D <= 128'h123456789abcdef0123456789abcdef;  
            hash_out <= 32'h0;  
        end else begin  
            // Example transformation process (not actual MD5)  
            F <= (A[31:0] & B[31:0]) | (~A[31:0] & C[31:0]);  
            A <= B;  
            B <= C;  
            C <= D;  
            D <= F;  
            hash_out <= D[31:0];  
        end  
    end  
endmodule