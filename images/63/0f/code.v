module top_module(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [15:0] data_in,
    output reg [15:0] data_out, // Changed from wire to reg
    output empty,
    output full,
    output reg [3:0] count
);parameter DEPTH = 16;
reg [15:0] buffer [0:DEPTH-1];
reg [3:0] head = 4'b0000;
reg [3:0] tail = 4'b0000;
reg [3:0] next_head;
reg [3:0] next_tail;

always @(posedge clk) begin
    if (rst) begin
        head <= 4'b0000;
        tail <= 4'b0000;
        count <= 4'b0000;
        data_out <= 16'b0; // Initialize data_out on reset
    end else begin
        next_head = head;
        next_tail = tail;
        if (wr_en & ~full) begin
            buffer[head] <= data_in;
            next_head = (head == DEPTH-1) ? 4'b0000 : head + 1;
            count <= count + 1;
        end
        if (rd_en & ~empty) begin
            data_out <= buffer[tail];
            next_tail = (tail == DEPTH-1) ? 4'b0000 : tail + 1;
            count <= count - 1;
        end
        head <= next_head;
        tail <= next_tail;
    end
end

assign empty = (count == 0);
assign full = (count == DEPTH);

endmodule