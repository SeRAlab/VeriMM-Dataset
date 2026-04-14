module chacha20_update (  
    input  wire [31:0] key,  
    input  wire [31:0] counter,  
    output wire [31:0] output_value  
);  
    wire [31:0] added_value;  
    assign added_value = key + counter;  
    assign output_value = {added_value[7:0], added_value[31:8]}; // Rotate left by 8 bits  
endmodule