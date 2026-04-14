module EEPROM (
    input wire clk,
    input wire we,      // write enable
    input wire re,      // read enable
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write data to memory
        end
        if (re) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule