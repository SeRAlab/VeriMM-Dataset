module eeprom_cell (
    input wire [3:0] data_in,
    input wire write_enable,
    output reg [3:0] data_out
);
    
    always @(*) begin
        if (write_enable) begin
            data_out = data_in; // Write operation
        end
        else begin
            // Read operation (output stored data)
            data_out = data_out; // Hold previous value
        end
    end

endmodule