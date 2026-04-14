module dram_cell (
    input wire clk,
    input wire we, // write enable
    input wire [15:0] din, // data input
    output reg [15:0] dout // data output
);

    reg [15:0] memory; // 16-bit memory cell

    always @(posedge clk) begin
        if (we) begin
            memory <= din; // Write data to memory
        end
        dout <= memory; // Always output stored memory
    end
endmodule