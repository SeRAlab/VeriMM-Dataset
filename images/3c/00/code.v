module dram_cell (
    input wire clk,
    input wire we,
    input wire [3:0] addr,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory [15:0]; // 16 registers of 16 bits each

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data
        end
    end

    always @(negedge clk) begin
        if (!we) begin
            data_out <= memory[addr]; // Read data
        end
    end
endmodule