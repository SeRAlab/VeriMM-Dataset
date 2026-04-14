module dram_cell (
    input wire clk,
    input wire write,
    input wire read,
    input wire [2:0] address,
    input wire data_in,
    output reg data_out
);

    reg [7:0] memory; // 8-bit memory array

    always @(posedge clk) begin
        if (write) begin
            memory[address] <= data_in; // Write data to the selected address
        end
    end

    always @(posedge clk) begin
        if (read) begin
            data_out <= memory[address]; // Read data from the selected address
        end
    end
endmodule