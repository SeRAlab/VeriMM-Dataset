module dram_cell (
    input wire clk,
    input wire we,
    input wire [7:0] d,
    input wire [2:0] addr,
    output reg q
);
    reg [7:0] memory [0:7]; // 8 x 8-bit memory array

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= d; // Write operation
        end
        q <= memory[addr]; // Read operation
    end
endmodule