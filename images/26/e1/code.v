module fifo_queue #(parameter DEPTH = 8, parameter WIDTH = 8) (
    input wire clk,
    input wire rst_n,
    input wire push,
    input wire pop,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output reg full,
    output reg empty
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [3:0] head;
    reg [3:0] tail;
    reg [3:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
            data_out <= 0;
        end else begin
            if (push && !full) begin
                mem[tail] <= data_in;
                tail <= (tail + 1) % DEPTH;
                count <= count + 1;
            end
            if (pop && !empty) begin
                data_out <= mem[head];
                head <= (head + 1) % DEPTH;
                count <= count - 1;
            end
            empty <= (count == 0);
            full <= (count == DEPTH);
        end
    end
endmodule