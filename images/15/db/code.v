module sram_cell (  
    input wire write_enable,  
    input wire data_in,  
    input wire clock,  
    output reg data_out  
);  
    reg stored_bit;  

    always @(posedge clock) begin  
        if (write_enable) begin  
            stored_bit <= data_in;  
        end  
    end  

    always @(*) begin  
        data_out = stored_bit;  
    end  
endmodule