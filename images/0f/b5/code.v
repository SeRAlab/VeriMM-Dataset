module mux4to1 (  
    input wire [3:0] data_in,  
    input wire [1:0] sel,  
    output wire data_out  
);  
    assign data_out = data_in[sel];  
endmodule