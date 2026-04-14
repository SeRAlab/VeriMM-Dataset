module fifo_buffer #(parameter DEPTH = 8, WIDTH = 8) (
    input clk,
    input rst,
    input push,
    input pop,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output reg full,
    output reg empty
);
    reg [WIDTH-1:0] buffer [0:DEPTH-1];
    reg [3:0] head, tail;
    reg [4:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (push && !full) begin
                buffer[head] <= data_in;
                head <= (head + 1) % DEPTH;
                count <= count + 1;
            end
            if (pop && !empty) begin
                data_out <= buffer[tail];
                tail <= (tail + 1) % DEPTH;
                count <= count - 1;
            end
            full <= (count == DEPTH);
            empty <= (count == 0);
        end
    end
endmodule