module top_module(
    input reset,
    input clk,
    input rd,
    input wr,
    input [7:0] data_in,
    output reg [7:0] data_out  // Added output for read data
);reg [7:0] fifo_array [0:15];
reg [3:0] head = 0;
reg [3:0] tail = 0;
reg full = 0;
reg empty = 1;

always @(posedge clk) begin
    if (reset) begin
        head <= 0;
        tail <= 0;
        full <= 0;
        empty <= 1;
        data_out <= 8'b0;  // Reset data_out on reset
    end else begin
        if (wr && !full) begin
            fifo_array[head] <= data_in;
            head <= head + 1;
            if (head == 16) begin
                head <= 0;
            end
            if (head == tail) begin
                full <= 1;
            end
            empty <= 0;
        end
        if (rd && !empty) begin
            data_out <= fifo_array[tail];  // Updated to use the output register
            fifo_array[tail] <= 0;
            tail <= tail + 1;
            if (tail == 16) begin
                tail <= 0;
            end
            if (tail == head) begin
                empty <= 1;
            end
            full <= 0;
        end
    end
end

endmodule