module top_module(
    input           rst_n,              // Asynchronous reset
    input           clk,                // System clock
    input           wr_en,              // Write enable
    input           rd_en,              // Read enable
    input           [7:0] data_in,      // Data input
    output reg      [7:0] data_out      // Data output
);parameter FIFO_DEPTH = 8;           // Depth of the FIFO
    parameter ADDR_WIDTH = 3;           // Address width of the FIFO
    parameter DATA_WIDTH = 8;           // Data width of the FIFO

    reg [ADDR_WIDTH-1:0] wr_addr;       // Write address
    reg [ADDR_WIDTH-1:0] rd_addr;       // Read address
    reg [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];   // FIFO memory

    // Write logic
    always @(posedge clk) begin
        if (!rst_n) begin
            wr_addr <= 0;
        end else if (wr_en) begin
            fifo[wr_addr] <= data_in;
            wr_addr <= wr_addr + 1;
        end
    end

    // Read logic
    always @(posedge clk) begin
        if (!rst_n) begin
            rd_addr <= 0;
        end else if (rd_en) begin
            data_out <= fifo[rd_addr];
            rd_addr <= rd_addr + 1;
        end
    end

endmodule