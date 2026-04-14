module fifo_queue #(parameter DATA_WIDTH = 8, parameter DEPTH = 16) (
    input clk,
    input reset,
    input enqueue,
    input dequeue,
    input [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg full,
    output reg empty
);

    reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];
    reg [3:0] head;
    reg [3:0] tail;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 0;
            tail <= 0;
            full <= 0;
            empty <= 1;
            data_out <= 0;
        end else begin
            if (enqueue && !full) begin
                fifo_mem[tail] <= data_in;
                tail <= (tail + 1) % DEPTH;
                empty <= 0;
                if (tail == head) full <= 1;
            end
            
            if (dequeue && !empty) begin
                data_out <= fifo_mem[head];
                head <= (head + 1) % DEPTH;
                full <= 0;
                if (head == tail) empty <= 1;
            end
        end
    end
endmodule