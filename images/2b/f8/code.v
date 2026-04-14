module eeprom (
    input wire clk,
    input wire [2:0] address, // 3 bits for 8 addresses
    input wire data_in,
    input wire write_enable,
    input wire erase_enable,
    output reg data_out
);
    reg [7:0] memory; // 8 bits for 8 cells

    always @(posedge clk) begin
        if (erase_enable) begin
            memory[address] <= 1'b0; // Erase operation
        end else if (write_enable) begin
            memory[address] <= data_in; // Write operation
        end
    end

    always @(*) begin
        data_out = memory[address]; // Read operation
    end
endmodule