module even_parity_generator #(parameter N = 8) (  
    input [N-1:0] data_in,  
    output parity_out  
);  
assign parity_out = ~^data_in;  
endmodule