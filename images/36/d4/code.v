module SRAM_8bit (
    input wire clk,
    input wire [2:0] addr,
    input wire [7:0] data_in,
    input wire WE,
    input wire RE,
    output reg [7:0] data_out
);
    reg [7:0] mem [0:7]; // 8 locations of 8-bit memory

    always @(posedge clk) begin
        if (WE) begin
            mem[addr] <= data_in; // Write data to memory
        end
        if (RE) begin
            data_out <= mem[addr]; // Read data from memory
        end
    end
endmodule