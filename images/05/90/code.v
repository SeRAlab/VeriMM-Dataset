module dram_cell (
    input wire clk,
    input wire we,
    input wire [15:0] data_in,
    input wire [3:0] addr,
    output reg [15:0] data_out
);
    reg [15:0] memory [15:0]; // 16 memory locations of 16 bits each

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write operation
        end
        data_out <= memory[addr]; // Read operation
    end
endmodule