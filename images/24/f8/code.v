module fifo_queue #(parameter DEPTH = 8, parameter DATA_WIDTH = 8) (
    input wire clk,
    input wire reset,
    input wire enqueue,
    input wire dequeue,
    input wire [DATA_WIDTH-1:0] data_in,
    output wire [DATA_WIDTH-1:0] data_out,
    output wire full,
    output wire empty
);
    reg [DATA_WIDTH-1:0] fifo_mem[0:DEPTH-1];
    reg [3:0] head, tail;
    reg [3:0] count;

    assign full = (count == DEPTH);
    assign empty = (count == 0);
    assign data_out = (empty) ? {DATA_WIDTH{1'b0}} : fifo_mem[head];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 0;
            tail <= 0;
            count <= 0;
        end else begin
            if (enqueue && !full) begin
                fifo_mem[tail] <= data_in;
                tail <= (tail + 1) % DEPTH;
                count <= count + 1;
            end
            if (dequeue && !empty) begin
                head <= (head + 1) % DEPTH;
                count <= count - 1;
            end
        end
    end
endmodule