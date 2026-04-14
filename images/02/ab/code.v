module eeprom_cell (
    input wire data_in,
    input wire write_enable,
    input wire read,
    output reg [4:0] data_out
);
    
    always @(*) begin
        if (write_enable) begin
            if (data_in) begin
                data_out = 5'b11111; // Store 1
            end else begin
                data_out = 5'b00000; // Store 0
            end
        end
    end

    // Always output the stored value when read signal is active
    always @(posedge read) begin
        // Do nothing, as data_out is already set during write
    end
endmodule