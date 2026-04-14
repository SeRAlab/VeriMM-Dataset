module ip_checksum (  
    input [15:0] word1,  
    input [15:0] word2,  
    input [15:0] word3,  
    input [15:0] word4,  
    input [15:0] word5,  
    output [15:0] checksum  
);  
    wire [31:0] sum;  
    assign sum = word1 + word2 + word3 + word4 + word5;  
    assign checksum = ~sum[15:0] + sum[16]; // One's complement + carry  
endmodule