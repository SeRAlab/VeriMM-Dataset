module dram_cell_controller (
    input wire clk,
    input wire we,
    input wire [3:0] addr,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 x 16-bit memory cells

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data to the selected address
        end else begin
            data_out <= memory[addr]; // Read data from the selected address
        end
    end
endmodule