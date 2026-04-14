module top_module(
    input clk,
    input reset,
    input enq,
    input deq,
    input [7:0] data_in,  // Added data_in input here
    output reg full,
    output reg empty,
    output reg [7:0] data_out
);reg [7:0] queue [0:7];
reg [2:0] head;
reg [2:0] tail;

always @(posedge clk or negedge reset) begin
    if (reset == 0) begin
        head <= 0;
        tail <= 0;
        full <= 0;
        empty <= 1;
    end else begin
        if (enq == 1 && full == 0) begin
            queue[head] <= data_in; // Correctly assigning data_in to queue
            head <= head + 1;
            if (head == 8) begin
                head <= 0;
            end
            if (head == tail) begin
                full <= 1;
            end
            empty <= 0;
        end
        if (deq == 1 && empty == 0) begin
            data_out <= queue[tail];
            queue[tail] <= 0;
            tail <= tail + 1;
            if (tail == 8) begin
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