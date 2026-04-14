module fifo_queue (
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty
);
    reg [7:0] fifo [7:0]; // 8 entries
    reg [2:0] head, tail; // 3 bits for indexing 8 entries
    reg [3:0] count; // Count of items in FIFO

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 3'b000;
            tail <= 3'b000;
            count <= 4'b0000;
            empty <= 1'b1;
            data_out <= 8'b00000000;
        end else begin
            if (wr_en && count < 4'b1000) begin // Check for overflow
                fifo[tail] <= data_in;
                tail <= (tail + 1) % 8;
                count <= count + 1;
                empty <= 1'b0;
            end
            if (rd_en && count > 0) begin // Check for underflow
                data_out <= fifo[head];
                head <= (head + 1) % 8;
                count <= count - 1;
                if (count == 1) empty <= 1'b1; // FIFO becomes empty
            end
        end
    end
endmodule