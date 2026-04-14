module turbo_encoder(  
    input wire data_in,  
    output wire encoded_out1,  
    output wire encoded_out2  
);  
    // Simple convolutional encoding logic  
    assign encoded_out1 = data_in;            // First output is same as input  
    assign encoded_out2 = ~data_in;           // Second output is the complement of input  
endmodule