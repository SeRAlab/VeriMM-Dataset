module sram_cell (  
    input wire data_in,  
    input wire write_enable,  
    input wire read_enable,  
    output reg data_out  
);  
    reg storage;  

    always @(posedge write_enable) begin  
        if (write_enable)  
            storage <= data_in;  
    end  

    always @(posedge read_enable) begin  
        if (read_enable)  
            data_out <= storage;  
    end  
endmodule