module EEPROM (
    input wire clk,
    input wire write_enable,
    input wire erase_enable,
    input wire [7:0] data_in,
    input wire [3:0] address,
    output reg [7:0] data_out
);

    reg [7:0] memory [15:0]; // 16x8 EEPROM memory

    always @(posedge clk) begin
        if (erase_enable) begin
            memory[address] <= 8'b0; // Erase operation
        end else if (write_enable) begin
            memory[address] <= data_in; // Write operation
        end
    end

    always @(posedge clk) begin
        if (!write_enable && !erase_enable) begin
            data_out <= memory[address]; // Read operation
        end
    end
endmodule