module fifo_queue (
    input clk,
    input rst,
    input [7:0] data_in,
    input wr_en,
    input rd_en,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] queue [3:0];
    reg [1:0] head, tail;
    reg [2:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 2'b00;
            tail <= 2'b00;
            count <= 3'b000;
            empty <= 1'b1;
            full <= 1'b0;
        end else begin
            if (wr_en && !full) begin
                queue[tail] <= data_in;
                tail <= (tail + 1) % 4;
                count <= count + 1;
            end
            if (rd_en && !empty) begin
                data_out <= queue[head];
                head <= (head + 1) % 4;
                count <= count - 1;
            end
            empty <= (count == 0);
            full <= (count == 4);
        end
    end
endmodule