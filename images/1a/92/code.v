module fifo_queue #(
    parameter DEPTH = 4,
    parameter DATA_WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg empty,
    output reg full
);

    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];
    reg [3:0] head, tail, count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            empty <= 1;
            full <= 0;
        end else begin
            if (wr_en && !full) begin
                memory[tail] <= data_in;
                tail <= (tail + 1) % DEPTH;
                count <= count + 1;
            end
            
            if (rd_en && !empty) begin
                data_out <= memory[head];
                head <= (head + 1) % DEPTH;
                count <= count - 1;
            end
            
            empty <= (count == 0);
            full <= (count == DEPTH);
        end
    end
endmodule