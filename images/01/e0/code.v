module sram_8bit (
    input wire [2:0] addr,
    input wire [7:0] data_in,
    input wire we,
    input wire clk,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:7]; // 8 locations of 8-bit memory

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write operation
        end
        data_out <= memory[addr]; // Read operation
    end
endmodule