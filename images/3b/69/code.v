module crc_generator (  
    input  [7:0] data_in,  
    output [7:0] crc_out  
);  
    wire [15:0] crc;  
    assign crc = {8'b0, data_in} ^ {8'b0, data_in} >> 8;  
    assign crc_out = crc[7:0];  
endmodule