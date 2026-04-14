module eeprom_cell (
    input wire clk,
    input wire we,         // write enable
    input wire [7:0] data_in, // data input
    output reg [7:0] data_out // data output
);
    // Internal register to store the data
    reg [7:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write data to memory
        end
        data_out <= memory; // Read data from memory
    end
endmodule