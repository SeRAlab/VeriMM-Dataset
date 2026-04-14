module dram_cell (
    input wire clk,
    input wire write,
    input wire read,
    input wire [15:0] din,
    output reg [15:0] dout
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (write) begin
            memory <= din; // Store data on write
        end
        if (read) begin
            dout <= memory; // Output data on read
        end
    end
endmodule