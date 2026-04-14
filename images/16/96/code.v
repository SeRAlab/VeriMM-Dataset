module sram_cell (
    input wire [3:0] address,
    input wire data_in,
    input wire read_enable,
    input wire write_enable,
    output reg data_out
);
    reg [15:0] memory; // 16-bit memory array

    always @(posedge write_enable) begin
        if (write_enable) begin
            memory[address] <= data_in; // Write operation
        end
    end

    always @(posedge read_enable) begin
        if (read_enable) begin
            data_out <= memory[address]; // Read operation
        end
    end
endmodule