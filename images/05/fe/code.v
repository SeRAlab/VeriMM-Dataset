module md5_hash (  
    input clk,  
    input reset,  
    input valid,  
    input [511:0] message,  
    output reg [127:0] hash,  
    output reg done  
);  

    reg [31:0] A, B, C, D;  
    reg [31:0] F;  
    reg [63:0] k;  
    reg [31:0] temp;  
    integer i;  

    initial begin  
        A = 32'h67452301;  
        B = 32'hefcdab89;  
        C = 32'h98badcfe;  
        D = 32'h10325476;  
        k = 0;  
        done = 0;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            A <= 32'h67452301;  
            B <= 32'hefcdab89;  
            C <= 32'h98badcfe;  
            D <= 32'h10325476;  
            hash <= 0;  
            done <= 0;  
        end else if (valid) begin  
            for (i = 0; i < 64; i = i + 1) begin  
                if (i < 16) begin  
                    F = (B & C) | (~B & D);  
                end else if (i < 32) begin  
                    F = (D & B) | (~D & C);  
                end else if (i < 48) begin  
                    F = B ^ C ^ D;  
                end else begin  
                    F = C ^ (B | ~D);  
                end  
                
                temp = A + F + message[i % 16] + k;  
                A <= D;  
                D <= C;  
                C <= B;  
                B <= B + {temp[31:1], temp[0]};  
                k = k + 1;  
            end  
            hash <= {A, B, C, D};  
            done <= 1;  
        end  
    end  
endmodule