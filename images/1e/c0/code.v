module ip_checksum(input [15:0] data_in, output [15:0] checksum);  
    wire [15:0] sum;  
    wire [16:0] extended_sum;  
    assign extended_sum = data_in + 16'b0;  
    assign sum = extended_sum[15:0] + extended_sum[16];  
    assign checksum = ~sum;  
endmodule