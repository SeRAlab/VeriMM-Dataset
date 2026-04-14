module eeprom_cell(  
    input wire data,  
    input wire write_enable,  
    input wire read_enable,  
    output reg q  
);  
    always @(posedge write_enable) begin  
        q <= data;  
    end  

    always @(posedge read_enable) begin  
        // This can also be done using combinational logic,  
        // but it's specified as sequential logic.  
        // Thus, we simply read the state on read_enable.  
    end  
endmodule