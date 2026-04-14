module eeprom_cell (
    input [3:0] data_in,
    input enable,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(*) begin
        if (enable) begin
            memory = data_in; // Write data to memory
        end
        data_out = memory; // Output the stored data
    end
endmodule