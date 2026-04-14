module eeprom_cell (
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    output reg data_out
);
    always @(posedge write_enable) begin
        if (write_enable) begin
            data_out <= data_in;
        end
    end

    always @(posedge read_enable) begin
        if (read_enable) begin
            // data_out is already updated with the latest written data
            // No additional action is needed here as it's always updated on write
        end
    end
endmodule