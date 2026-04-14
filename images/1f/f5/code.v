module checksum_calculator(  
    input [3:0] data_in,  
    output [3:0] checksum_out  
);  
    assign checksum_out = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3];  
endmodule