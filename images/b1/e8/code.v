module top_module(
    input clk,
    input reset,
    input [WIDTH-1:0] i_data,
    input i_valid,
    input i_stall,
    output reg o_valid,
    output reg [WIDTH-1:0] o_data,
    output o_full,
    output reg o_next_valid,
    output reg [WIDTH-1:0] o_next_data
);parameter WIDTH=32;
parameter DEPTH=32;

reg [WIDTH-1:0] fifo [0:DEPTH-1]; // FIFO storage
reg [4:0] write_ptr = 0;           // Write pointer
reg [4:0] read_ptr = 0;            // Read pointer
reg [4:0] count = 0;                // Count of items in FIFO

assign o_full = (count == DEPTH);  // FIFO is full
assign sr_ready = !o_valid || !i_stall;

// FIFO Write Logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        write_ptr <= 0;
        read_ptr <= 0;
        count <= 0;
    end else begin
        if (i_valid && !o_full) begin
            fifo[write_ptr] <= i_data;
            write_ptr <= (write_ptr + 1) % DEPTH;
            count <= count + 1;
        end
    end
end

// FIFO Read Logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        o_valid <= 1'b0;
        o_next_valid <= 1'b0;
        o_data <= 0;
        o_next_data <= 0;
    end else begin
        if (count > 0) begin
            o_next_data <= fifo[read_ptr];
            o_next_valid <= 1'b1;
            if (!i_stall) begin
                o_data <= o_next_data;
                o_valid <= 1'b1;
                read_ptr <= (read_ptr + 1) % DEPTH;
                count <= count - 1;
            end
        end else begin
            o_next_valid <= 1'b0;
            o_valid <= 1'b0;
        end
    end
end

endmodule