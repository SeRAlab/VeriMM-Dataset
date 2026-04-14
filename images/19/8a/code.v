module dram_cell (
    input wire [15:0] data_in,
    input wire [3:0] addr,
    input wire we,
    input wire clk,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 x 16-bit memory

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write operation
        end else begin
            data_out <= memory[addr]; // Read operation
        end
    end
endmodule