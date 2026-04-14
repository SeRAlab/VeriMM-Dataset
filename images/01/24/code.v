module SRAM_4bit (
    input wire [3:0] data_in,
    input wire addr,
    input wire write_enable,
    input wire clk,
    output reg [3:0] data_out
);

reg [3:0] memory [1:0]; // 4-bit memory with 2 addresses

always @(posedge clk) begin
    if (write_enable) begin
        memory[addr] <= data_in; // Write data to memory
    end
    data_out <= memory[addr]; // Read data from memory
end

endmodule