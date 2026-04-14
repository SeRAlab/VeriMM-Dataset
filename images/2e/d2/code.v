module eeprom_cell (  
    input [3:0] D,  
    input WE,  
    output reg [3:0] Q  
);  
    always @(*) begin  
        if (WE)  
            Q = D;  
    end  
endmodule