module eeprom_cell (  
    input clk,  
    input write_enable,  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  

    reg [7:0] memory;  

    always @(posedge clk) begin  
        if (write_enable) begin  
            memory <= data_in;  
        end  
        data_out <= memory;  
    end  
endmodule