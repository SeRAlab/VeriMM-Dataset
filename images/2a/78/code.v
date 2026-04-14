module dram_cell (
    input wire clk,
    input wire we,
    input wire re,
    input wire [7:0] d,
    output reg [7:0] q
);
    reg [7:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= d; // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (re) begin
            q <= memory; // Read data from memory
        end
    end
endmodule