module even_parity_generator(  
    input [7:0] data,  
    output parity  
);  
    assign parity = ~(data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[5] ^ data[6] ^ data[7]);  
endmodule