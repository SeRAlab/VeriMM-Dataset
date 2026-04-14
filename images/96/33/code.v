module top_module(
    input clk,
    input wr,
    input [7:0] din,
    output rd,
    output reg [7:0] dout // Change dout to reg type
);reg [7:0] mem [0:7]; // Memory for storing FIFO elements
reg [2:0] wr_ptr = 0; // Write pointer should be 3 bits
reg [2:0] rd_ptr = 0; // Read pointer should be 3 bits
reg empty = 1; // Flag indicating whether FIFO is empty
reg full = 0; // Flag indicating whether FIFO is full

// Write logic
always @(posedge clk) begin
    if (wr && !full) begin
        mem[wr_ptr] <= din;
        wr_ptr <= wr_ptr + 1;
        if (wr_ptr == 7) begin // Update from 8 to 7 for 0-7 indexing
            wr_ptr <= 0;
        end
        if (wr_ptr + 1 == rd_ptr) begin // Adjust full condition
            full <= 1;
        end
        empty <= 0;
    end
end

// Read logic
always @(posedge clk) begin
    if (rd && !empty) begin
        dout <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        if (rd_ptr == 7) begin // Update from 8 to 7 for 0-7 indexing
            rd_ptr <= 0;
        end
        if (rd_ptr + 1 == wr_ptr) begin // Adjust empty condition
            empty <= 1;
        end
        full <= 0;
    end
end

// Output logic
assign rd = !empty;

endmodule