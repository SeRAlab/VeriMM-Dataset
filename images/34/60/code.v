module dram_cell (
    input wire clk,
    input wire rst,
    input wire we,
    input wire re,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            memory <= 16'b0; // Reset the memory
        end else if (we) begin
            memory <= data_in; // Write operation
        end
    end

    always @(posedge clk) begin
        if (re) begin
            data_out <= memory; // Read operation
        end
    end
endmodule