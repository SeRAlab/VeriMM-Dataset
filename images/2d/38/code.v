module eeprom_cell(  
    input wire [4:0] data_in,  
    input wire write_enable,  
    output reg [4:0] data_out  
);  
  
    reg [4:0] stored_value;  
  
    always @(*) begin  
        if (write_enable) begin  
            stored_value = data_in;  
        end  
        data_out = stored_value;  
    end  
endmodule