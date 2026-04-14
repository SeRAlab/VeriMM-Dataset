module crc_generator(  
    input [3:0] data,  
    output [3:0] crc  
);  
    assign crc[3] = data[3] ^ data[2];  
    assign crc[2] = data[2] ^ data[1] ^ data[3];  
    assign crc[1] = data[1] ^ data[0] ^ data[2];  
    assign crc[0] = data[0] ^ data[1];  
endmodule