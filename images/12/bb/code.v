module fifo_queue (
    input clk,
    input rst,
    input [4:0] data_in,
    input write_en,
    input read_en,
    output reg [4:0] data_out,
    output reg empty,
    output reg full
);
    reg [4:0] fifo [3:0]; // 4 depth FIFO
    reg [1:0] head, tail;
    reg [2:0] count;

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
                tail <= (tail + 1) % 4;
                count <= count + 1;
            end
            if (read_en && !empty) begin
                data_out <= fifo[head];
                head <= (head + 1) % 4;
                count <= count - 1;
            end
            
            empty <= (count == 0);
            full <= (count == 4);
        end
    end
endmodule