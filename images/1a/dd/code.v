module md5_hash(input clk,  
                 input reset,  
                 input [511:0] message,  
                 input valid,  
                 output reg [127:0] hash);  

    // MD5 Constants  
    reg [31:0] A, B, C, D;  
    reg [31:0] F, G;  

    initial begin  
        A = 32'h67452301;  
        B = 32'hEFCDAB89;  
        C = 32'h98BADCFE;  
        D = 32'h10325476;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            A <= 32'h67452301;  
            B <= 32'hEFCDAB89;  
            C <= 32'h98BADCFE;  
            D <= 32'h10325476;  
            hash <= 128'b0;  
        end else if (valid) begin  
            // Simplified hash computation logic (not actual MD5)  
            // This logic should be replaced with the actual MD5 algorithm  
            F = (B & C) | (~B & D);  
            G = (A + F + message[15:0]) % 2**32;  
            A <= D;  
            D <= C;  
            C <= B;  
            B <= G;  
            hash <= {A, B, C, D};  
        end  
    end  
endmodule