module ip_checksum (  
    input [15:0] word0,  
    input [15:0] word1,  
    input [15:0] word2,  
    input [15:0] word3,  
    input [15:0] word4,  
    input [15:0] word5,  
    input [15:0] word6,  
    input [15:0] word7,  
    input valid,  
    output reg [15:0] checksum  
);  
    wire [31:0] sum;  
    assign sum = word0 + word1 + word2 + word3 + word4 + word5 + word6 + word7;  

    always @(*) begin  
        if (valid) begin  
            checksum = ~((sum[15:0] + sum[31:16]));  
        end else begin  
            checksum = 16'h0000;  
        end  
    end  
endmodule