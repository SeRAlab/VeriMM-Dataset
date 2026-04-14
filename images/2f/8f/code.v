module dram_cell (
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    input wire rw, // 1 for write, 0 for read
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 4'b0000;
            data_out <= 4'b0000;
        end else if (rw) begin
            memory <= data_in; // Write operation
        end else begin
            data_out <= memory; // Read operation
        end
    end
endmodule