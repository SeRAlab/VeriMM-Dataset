module fifo #(parameter DEPTH = 8, DATA_WIDTH = 8) (
    input wire clk,
    input wire rst,
    input wire [DATA_WIDTH-1:0] data_in,
    input wire enqueue,
    input wire dequeue,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg full,
    output reg empty
);
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [3:0] head;
    reg [3:0] tail;
    reg [4:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            empty <= 1;
            full <= 0;
        end else begin
            if (enqueue && !full) begin
                mem[tail] <= data_in;
                tail <= (tail + 1) % DEPTH;
                count <= count + 1;
            end
            if (dequeue && !empty) begin
                data_out <= mem[head];
                head <= (head + 1) % DEPTH;
                count <= count - 1;
            end
            empty <= (count == 0);
            full <= (count == DEPTH);
        end
    end
endmodule