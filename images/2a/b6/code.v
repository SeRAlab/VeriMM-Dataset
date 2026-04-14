module dram_cell (
    input wire clk,
    input wire rst,
    input wire we,        // Write Enable
    input wire re,        // Read Enable
    input wire [15:0] din, // Data input
    output reg [15:0] dout // Data output
);
    reg [15:0] memory; // 16-bit memory cell

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            memory <= 16'b0; // Clear memory on reset
            dout <= 16'b0;   // Clear output on reset
        end else begin
            if (we) begin
                memory <= din; // Write data to memory on write enable
            end
            if (re) begin
                dout <= memory; // Output memory data on read enable
            end
        end
    end
endmodule