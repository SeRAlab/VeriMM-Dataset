module SRAM_8bit (
    input wire [7:0] data_in,
    input wire [2:0] address,
    input wire rw, // rw = 1 for write, rw = 0 for read
    output reg [7:0] data_out
);
    reg [7:0] memory [7:0]; // 8-bit memory with 8 addresses

    always @(posedge rw) begin
        if (rw) begin
            memory[address] <= data_in; // Write operation
        end
        else begin
            data_out <= memory[address]; // Read operation
        end
    end
endmodule