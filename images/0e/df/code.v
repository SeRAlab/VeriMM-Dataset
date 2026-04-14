module dac_24_to_8 (  
    input [23:0] data_in,  
    output [7:0] data_out  
);  
    assign data_out = data_in[23:16];  
endmodule