module eeprom_cell(  
    input [4:0] data_in,  
    input we,  
    output reg [4:0] data_out  
);  
    always @(*) begin  
        if (we)  
            data_out = data_in;  
    end  
endmodule