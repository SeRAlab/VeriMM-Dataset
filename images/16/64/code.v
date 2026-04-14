module ip_checksum_calculator(  
    input [31:0] data_in,  
    output [15:0] checksum_out  
);  
    wire [15:0] word1 = data_in[31:16];  
    wire [15:0] word2 = data_in[15:0];  
    wire [16:0] sum = word1 + word2;  
    assign checksum_out = ~sum[15:0];  
endmodule