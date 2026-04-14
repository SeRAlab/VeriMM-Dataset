module eeprom_cell (
    input [4:0] data_in,
    input read_enable,
    output reg [4:0] data_out
);

always @(*) begin
    if (read_enable) begin
        data_out = data_in; // Output the input data when read_enable is high
    end else begin
        data_out = 5'b00000; // Output zero when read_enable is low
    end
end

endmodule