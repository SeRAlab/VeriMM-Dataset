module md5_simple(input clk, input [63:0] data, output reg [31:0] hash);  
    // Internal registers  
    reg [31:0] A, B, C, D;  
    reg [31:0] F;  
    integer i;  

    always @(posedge clk) begin  
        // Initialize registers  
        A <= 32'h67452301;  
        B <= 32'hEFCDAB89;  
        C <= 32'h98BADCFE;  
        D <= 32'h10325476;  

        // Simple transformations mimicking MD5  
        for (i = 0; i < 64; i = i + 1) begin  
            F = (B & C) | (~B & D);  
            A <= B + ((A + F + data[i % 8] + (i + 1)) << (i % 32));  
            B <= A;  
            C <= B;  
            D <= C;  
        end  
        hash <= A;  
    end  
endmodule