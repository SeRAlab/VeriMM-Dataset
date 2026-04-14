module eeprom_cell (
    input wire clk,
    input wire we,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write operation
        end
        data_out <= memory; // Read operation
    end
endmodule