module top_module(
    input clk,
    input [57:0] din,
    input wr_en,
    input rd_en,
    output reg [57:0] dout,
    output reg empty,
    output reg full
);reg [3:0] wr_ptr, rd_ptr;
reg [57:0] mem [0:15];

always @(posedge clk) begin
    // Write data to FIFO
    if (wr_en && !full) begin
        mem[wr_ptr] <= din;
        wr_ptr <= wr_ptr + 1;
    end
    // Read data from FIFO
    if (rd_en && !empty) begin
        dout <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
    end
end

// Update empty and full signals
always @* begin
    empty = (wr_ptr == rd_ptr);
    full = (wr_ptr == rd_ptr + 16);
end

endmodule