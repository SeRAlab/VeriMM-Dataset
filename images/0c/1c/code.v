module eeprom_cell(  
    input [4:0] data_in,  
    input we,  
    output reg [4:0] data_out  
);  
    always @(*) begin  
        if (we) begin  
            data_out = data_in;  
        end else begin  
            // Maintain the current value of data_out when we is low  
            data_out = data_out;  
        end  
    end  
endmodule