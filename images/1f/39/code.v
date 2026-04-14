module SRAM (
    input wire write_enable,
    input wire read_enable,
    input wire [1:0] address,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);

    reg [3:0] memory [0:3]; // 4 x 4-bit memory cells

    always @(posedge write_enable) begin
        if (write_enable) begin
            memory[address] <= data_in; // Write data into memory
        end
    end

    always @(posedge read_enable) begin
        if (read_enable) begin
            data_out <= memory[address]; // Read data from memory
        end
    end

endmodule