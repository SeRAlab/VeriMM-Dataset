module dram_cell (
    input wire clk,
    input wire we,
    input wire re,
    input wire rst,
    input wire [7:0] din,
    output reg [7:0] dout
);

    reg [7:0] memory;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            memory <= 8'b0;
            dout <= 8'b0;
        end else if (we) begin
            memory <= din;
        end else if (re) begin
            dout <= memory;
        end
    end
endmodule