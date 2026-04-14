module checksum_generator(  
    input wire [3:0] data,  
    input wire reset,  
    output wire [3:0] checksum  
);  
    assign checksum = reset ? 4'b0000 : (data[0] ^ data[1] ^ data[2] ^ data[3]);  
endmodule