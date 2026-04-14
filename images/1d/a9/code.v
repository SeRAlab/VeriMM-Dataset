module sram_cell (  
    input wire write_enable,  
    input wire read_enable,  
    input wire data_in,  
    output reg data_out  
);  
    reg stored_bit;  

    always @(posedge write_enable) begin  
        stored_bit <= data_in;  
    end  

    always @(posedge read_enable) begin  
        data_out <= stored_bit;  
    end  
endmodule