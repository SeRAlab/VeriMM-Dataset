module sram_8bit (
    input wire [7:0] data_in,
    input wire [2:0] address,
    input wire we,
    input wire clk,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:7]; // 8-bit SRAM with 8 addresses

    always @(posedge clk) begin
        if (we) begin
            memory[address] <= data_in; // Write data to the specified address
        end else begin
            data_out <= memory[address]; // Read data from the specified address
        end
    end
endmodule