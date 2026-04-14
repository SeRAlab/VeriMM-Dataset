module parity_generator(  
    input [7:0] data_in,  
    output parity_out  
);  
    assign parity_out = ^data_in; // XOR reduction for even parity  
endmodule