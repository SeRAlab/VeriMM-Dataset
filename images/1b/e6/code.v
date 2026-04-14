module eeprom_cell (
    input wire [7:0] data_in,
    input wire rw,         // 1 for read, 0 for write
    input wire enable,
    input wire erase,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @ (posedge enable) begin
        if (erase) begin
            memory <= 8'hFF;  // Set to default value
        end else if (rw == 0) begin
            memory <= data_in; // Write operation
        end else begin
            data_out <= memory; // Read operation
        end
    end
endmodule