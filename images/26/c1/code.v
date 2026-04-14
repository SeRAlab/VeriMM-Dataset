module fifo_queue (
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);

    reg [7:0] fifo [7:0]; // 8 x 8-bit FIFO
    reg [2:0] head, tail, count;

    initial begin
        head = 3'b000;
        tail = 3'b000;
        count = 3'b000;
        full = 1'b0;
        empty = 1'b1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 3'b000;
            tail <= 3'b000;
            count <= 3'b000;
            full <= 1'b0;
            empty <= 1'b1;
        end else begin
            if (wr_en && !full) begin
                fifo[tail] <= data_in;
                tail <= (tail + 1) % 8;
                count <= count + 1;
            end
            
            if (rd_en && !empty) begin
                data_out <= fifo[head];
                head <= (head + 1) % 8;
                count <= count - 1;
            end
            
            full <= (count == 3'b111);
            empty <= (count == 3'b000);
        end
    end
endmodule