module eeprom_cell (  
    input wire CLK,  
    input wire WE,  
    input wire [7:0] D,  
    output reg [7:0] Q  
);  

    always @(posedge CLK) begin  
        if (WE)  
            Q <= D;  
    end  
endmodule