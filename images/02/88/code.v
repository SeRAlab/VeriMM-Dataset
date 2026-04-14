module dram_cell (
    input wire [7:0] data_in,
    input wire [2:0] addr,
    input wire we,
    input wire clk,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:7]; // 8 x 8-bit memory cells

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write operation
        end
        else begin
            data_out <= memory[addr]; // Read operation
        end
    end
endmodule