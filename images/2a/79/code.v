module dram_16bit (
    input wire clk,
    input wire we,
    input wire [3:0] addr,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 locations of 16-bit memory

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write operation
        end
        data_out <= memory[addr]; // Read operation
    end
endmodule