module dram_cell (
    input wire clk,
    input wire we,        // Write enable
    input wire [7:0] din, // Data input
    output reg [7:0] dout // Data output
);
    reg [7:0] mem;

    always @(posedge clk) begin
        if (we) begin
            mem <= din;    // Write data to memory
        end
        dout <= mem;       // Output memory data
    end
endmodule