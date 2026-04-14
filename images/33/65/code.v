module eeprom_driver(  
    input [4:0] data_in,  
    input write,  
    output reg [4:0] data_out  
);  
    always @(*) begin  
        if (write)  
            data_out = data_in;  
        // else retain previous value (implicit)  
    end  
endmodule