module eeprom_cell(  
    input wire D,  
    input wire WE,  
    output reg Q  
);  
    always @(*) begin  
        if (WE)  
            Q = D;  
    end  
endmodule