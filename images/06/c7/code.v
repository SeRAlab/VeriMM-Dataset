module eeprom_cell (
    input [4:0] data_in,
    input write_en,
    output reg [4:0] data_out
);
    
    always @(*) begin
        if (write_en) begin
            data_out = data_in; // Store data when write enable is high
        end
    end
endmodule