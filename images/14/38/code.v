module flash_memory_cell(  
    input wire write_enable,  
    input wire read_enable,  
    input wire data_in,  
    output reg data_out  
);  
    always @(posedge write_enable or posedge read_enable) begin  
        if (write_enable) begin  
            data_out <= data_in;  
        end  
    end  
endmodule