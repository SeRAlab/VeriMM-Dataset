module dram_cell (
    input wire clk,
    input wire reset,
    input wire write,
    input wire read,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 4'b0000;
        end else if (write) begin
            memory <= data_in;
        end else if (read) begin
            data_out <= memory;
        end
    end
endmodule