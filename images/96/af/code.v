module top_module(
    input clk,
    input reset,
    input write_en,
    input [31:0] write_data,
    input read_en,
    output fifo_is_empty,
    output fifo_is_full,
    output reg [6:0] words_used,
    output reg [31:0] read_data
);reg [31:0] fifo [127:0];
reg [6:0] head;
reg [6:0] tail;
reg full;
reg empty;

always @(posedge clk) begin
    if (reset) begin
        head <= 0;
        tail <= 0;
        full <= 0;
        empty <= 1;
        words_used <= 0;
        read_data <= 0;
    end else begin
        if (write_en && !full) begin
            fifo[head] <= write_data;
            head <= head + 1;
            if (head == 128) begin
                head <= 0;
            end
            words_used <= words_used + 1;
            if (words_used == 128) begin
                full <= 1;
            end
            empty <= 0;
        end
        if (read_en && !empty) begin
            read_data <= fifo[tail];
            tail <= tail + 1;
            if (tail == 128) begin
                tail <= 0;
            end
            words_used <= words_used - 1;
            if (words_used == 0) begin
                empty <= 1;
            end
            full <= 0;
        end
    end
end

assign fifo_is_empty = empty;
assign fifo_is_full = full;

endmodule