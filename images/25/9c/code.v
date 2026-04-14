module eeprom_cell (
    input wire we,
    input wire [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] stored_data;

    always @(*) begin
        if (we) begin
            stored_data = data_in;  // Write data to EEPROM
        end
        data_out = stored_data;    // Always output the stored data
    end
endmodule