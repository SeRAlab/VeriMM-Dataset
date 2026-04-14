module md5_checksum(input [3:0] data, output [3:0] checksum);  
    assign checksum = data[3] ^ data[2] ^ data[1] ^ data[0];  
endmodule