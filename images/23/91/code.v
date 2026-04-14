module dram_cell (
    input wire [15:0] d,      // Data input
    output reg [15:0] q,      // Data output
    input wire re,            // Read enable
    input wire we,            // Write enable
    input wire clk            // Clock
);
    reg [15:0] storage;       // Internal storage for the DRAM cell

    always @(posedge clk) begin
        if (we) begin
            storage <= d;      // Write data to storage
        end
        if (re) begin
            q <= storage;      // Read data from storage
        end
    end
endmodule