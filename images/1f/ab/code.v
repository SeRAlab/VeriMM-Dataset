module ip_checksum_calculator(  
    input [31:0] data_in,  
    output [15:0] checksum_out  
);  
    wire [15:0] word1;  
    wire [15:0] word2;  
    wire [15:0] sum;  
    wire [15:0] wrapped_sum;  
    wire [15:0] final_sum;  

    assign word1 = data_in[31:16];  
    assign word2 = data_in[15:0];  
    assign sum = word1 + word2;  
    assign wrapped_sum = sum + (sum >> 16);  
    assign final_sum = ~wrapped_sum;  

    assign checksum_out = final_sum;  
endmodule