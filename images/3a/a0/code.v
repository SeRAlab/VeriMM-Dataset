module fifo_queue #(parameter SIZE = 4, DATA_WIDTH = 8) (
    input wire clk,
    input wire rst,
    input wire enqueue,
    input wire dequeue,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg empty,
    output reg full,
    output reg [2:0] current_size
);

    reg [DATA_WIDTH-1:0] fifo_mem [0:SIZE-1];
    reg [1:0] head, tail;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            current_size <= 0;
            empty <= 1;
            full <= 0;
        end else begin
            if (enqueue && !full) begin
                fifo_mem[tail] <= data_in;
                tail <= (tail + 1) % SIZE;
                current_size <= current_size + 1;
            end
            if (dequeue && !empty) begin
                data_out <= fifo_mem[head];
                head <= (head + 1) % SIZE;
                current_size <= current_size - 1;
            end
            
            empty <= (current_size == 0);
            full <= (current_size == SIZE);
        end
    end
endmodule