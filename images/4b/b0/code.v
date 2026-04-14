module fifo_8bit(
    input clk,           // Clock signal.
    input rst_n,         // Active-low reset signal.
    input write_en,      // Write enable signal.
    input read_en,       // Read enable signal.
    input [7:0] data_in, // 8-bit data input.

    output [7:0] data_out, // 8-bit data output.
    output full,           // FIFO full status signal.
    output empty           // FIFO empty status signal.
);

reg [7:0] fifo_mem [0:15]; // FIFO memory array.
reg [3:0] write_ptr;       // Write pointer.
reg [3:0] read_ptr;        // Read pointer.
reg full_r, empty_r;       // Status flags.

//------------------------------------------------
// Manage write operations
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        write_ptr <= 4'd0;
        full_r <= 1'b0;
    end
    else if (write_en && !full_r) begin
        fifo_mem[write_ptr] <= data_in;
        write_ptr <= write_ptr + 1'b1;
        if (write_ptr == 4'd15)
            full_r <= 1'b1;
    end
end

//------------------------------------------------
// Manage read operations
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_ptr <= 4'd0;
        empty_r <= 1'b1;
    end
    else if (read_en && !empty_r) begin
        read_ptr <= read_ptr + 1'b1;
        if (read_ptr == 4'd15)
            empty_r <= 1'b1;
    end
end

//------------------------------------------------
// Update empty flag
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        empty_r <= 1'b1;
    else if (write_en && !full_r)
        empty_r <= 1'b0;
    else if (read_en && (read_ptr == write_ptr))
        empty_r <= 1'b1;
end

assign data_out = fifo_mem[read_ptr];
assign full = full_r;
assign empty = empty_r;

endmodule