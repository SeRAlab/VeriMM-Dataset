module eeprom_controller (
    input [4:0] data_in,
    input write_enable,
    output reg [4:0] data_out
);
    reg [4:0] memory_cell;

    always @(*) begin
        if (write_enable) begin
            memory_cell = data_in; // Write data to memory cell
        end
        data_out = memory_cell; // Read data from memory cell
    end
endmodule