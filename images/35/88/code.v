module eeprom_cell (
    input wire we,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    always @(*) begin
        if (we) begin
            data_out = data_in; // Write operation
        end else begin
            // Do nothing, keep the stored value
            data_out = data_out; // Read operation
        end
    end
endmodule