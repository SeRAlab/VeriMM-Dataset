module fifo_queue #(parameter DEPTH = 8, WIDTH = 8) (
    input wire clk,
    input wire rst,
    input wire enqueue,
    input wire dequeue,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output reg full,
    output reg empty
);
    reg [WIDTH-1:0] memory [0:DEPTH-1];
    reg [3:0] wr_ptr;
    reg [3:0] rd_ptr;
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (enqueue && !full) begin
                memory[wr_ptr] <= data_in;
                wr_ptr <= (wr_ptr + 1) % DEPTH;
                count <= count + 1;
            end
            if (dequeue && !empty) begin
                data_out <= memory[rd_ptr];
                rd_ptr <= (rd_ptr + 1) % DEPTH;
                count <= count - 1;
            end
            
            empty <= (count == 0);
            full <= (count == DEPTH);
        end
    end
endmodule