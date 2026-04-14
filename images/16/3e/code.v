module SRAM_Cell (
    input wire clk,
    input wire we,       // write enable
    input wire re,       // read enable
    input wire [7:0] din, // data input
    output reg [7:0] dout // data output
);
    reg [7:0] memory;   // 8-bit memory storage

    always @(posedge clk) begin
        if (we) begin
            memory <= din; // write data to memory
        end
    end

    always @(posedge clk) begin
        if (re) begin
            dout <= memory; // output data from memory
        end
    end
endmodule