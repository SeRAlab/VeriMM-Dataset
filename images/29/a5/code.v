module fifo_queue #(parameter DEPTH = 8, parameter DATA_WIDTH = 8) (
    input clk,
    input rst,
    input [DATA_WIDTH-1:0] data_in,
    input write_en,
    input read_en,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg empty,
    output reg full
);
    reg [DATA_WIDTH-1:0] fifo [0:DEPTH-1];
    reg [3:0] head, tail;
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            empty <= 1;
            full <= 0;
        end else begin
            if (write_en && !full) begin
                fifo[tail] <= data_in;
                tail <= (tail + 1) % DEPTH;
                count <= count + 1;
            end
            if (read_en && !empty) begin
                data_out <= fifo[head];
                head <= (head + 1) % DEPTH;
                count <= count - 1;
            end
            
            empty <= (count == 0);
            full <= (count == DEPTH);
        end
    end
endmodule