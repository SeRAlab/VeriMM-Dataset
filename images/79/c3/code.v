module top_module(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output reg [7:0] data_out  // Changed to reg type
);parameter DEPTH = 16;

reg [7:0] fifo[0:DEPTH-1];
reg [3:0] head;
reg [3:0] tail;
reg full;
reg empty;

always @(posedge clk) begin
    if (rst) begin
        head <= 0;
        tail <= 0;
        full <= 0;
        empty <= 1;
        data_out <= 0; // Initialize data_out on reset
    end else begin
        if (wr_en && !full) begin
            fifo[head] <= data_in;
            head <= (head == DEPTH-1) ? 0 : head + 1;
            full <= (head + 1 == tail); // Update full condition
            empty <= 0;
        end
        if (rd_en && !empty) begin
            data_out <= fifo[tail];
            tail <= (tail == DEPTH-1) ? 0 : tail + 1;
            full <= 0; // No need to set full here
            empty <= (head == tail);
        end
    end
end

endmodule