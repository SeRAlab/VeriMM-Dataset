module dram_cell(
    input wire clk,
    input wire wr_en,   // write enable
    input wire rd_en,   // read enable
    input wire [15:0] din, // data input
    output reg [15:0] dout // data output
);
    reg [15:0] memory; // Internal storage for the DRAM cell

    always @(posedge clk) begin
        if (wr_en) begin
            memory <= din; // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (rd_en) begin
            dout <= memory; // Read data from memory
        end
    end
endmodule