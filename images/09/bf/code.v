module sram_cell (
    input wire [15:0] data_in,
    input wire write_enable,
    input wire [3:0] addr,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 SRAM cells

    always @(posedge write_enable) begin
        if (write_enable) begin
            memory[addr] <= data_in; // Write data to memory
        end
    end

    always @(posedge write_enable) begin
        data_out <= memory[addr]; // Read data from memory
    end
endmodule