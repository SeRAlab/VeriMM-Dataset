module eeprom_cell (  
    input wire clk,  
    input wire write,  
    input wire data_in,  
    input wire read,  
    output reg data_out  
);  
    reg stored_data;  

    always @(posedge clk) begin  
        if (write) begin  
            stored_data <= data_in;  
        end  
    end  

    always @(posedge clk) begin  
        if (read) begin  
            data_out <= stored_data;  
        end  
    end  
endmodule