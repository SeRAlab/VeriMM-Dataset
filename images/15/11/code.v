module eeprom (
    input [3:0] data_in,
    input write_enable,
    input read_enable,
    input erase_enable,
    output reg [3:0] data_out,
    output reg busy
);
    reg [3:0] memory;

    always @(posedge write_enable or posedge read_enable or posedge erase_enable) begin
        busy <= 1; // Set busy on any operation
        if (erase_enable) begin
            memory <= 4'b0000; // Erase memory
        end else if (write_enable) begin
            memory <= data_in; // Write data
        end else if (read_enable) begin
            data_out <= memory; // Read data
        end
        busy <= 0; // Reset busy after operation
    end
endmodule