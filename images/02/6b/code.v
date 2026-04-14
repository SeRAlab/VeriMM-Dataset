module eeprom_cell (  
    input wire clk,  
    input wire write_enable,  
    input wire read_enable,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory;  

    always @(posedge clk) begin  
        if (write_enable)  
            memory <= data_in;  
        if (read_enable)  
            data_out <= memory;  
    end  
endmodule