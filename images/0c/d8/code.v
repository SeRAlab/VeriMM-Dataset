module dram_cell (
    input wire clk,
    input wire we,         // write enable
    input wire [7:0] din, // data input
    output reg [7:0] dout // data output
);
    always @(posedge clk) begin
        if (we) begin
            dout <= din; // Store data
        end
    end
endmodule