module md5_hash (  
    input wire clk,  
    input wire reset,  
    input wire [31:0] data_in,  
    output reg [31:0] hash_out  
);  

    reg [31:0] A, B, C, D;  
    wire [31:0] F, G, H;  
    wire [31:0] rotated;  

    initial begin  
        A = 32'h67452301;  
        B = 32'hefcdab89;  
        C = 32'h98badcfe;  
        D = 32'h10325476;  
    end  

    assign F = (B & C) | (~B & D);  
    assign G = (A + F + data_in + 32'hD76AA478);  
    assign rotated = {G[30:0], G[31]};  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            hash_out <= 32'h00000000;  
        end else begin  
            A <= D;  
            D <= C;  
            C <= B;  
            B <= B + rotated;  
            hash_out <= B;  
        end  
    end  
endmodule