module fifo_queue #(parameter DATA_WIDTH = 8, parameter FIFO_DEPTH = 4) (
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg full,
    output reg empty
);

reg [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];
reg [2:0] head;
reg [2:0] tail;
reg [2:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        head <= 0;
        tail <= 0;
        count <= 0;
        full <= 0;
        empty <= 1;
    end else begin
        // Write operation
        if (wr_en && !full) begin
            fifo[tail] <= data_in;
            tail <= (tail + 1) % FIFO_DEPTH;
            count <= count + 1;
        end
        
        // Read operation
        if (rd_en && !empty) begin
            data_out <= fifo[head];
            head <= (head + 1) % FIFO_DEPTH;
            count <= count - 1;
        end

        // Update full and empty flags
        full <= (count == FIFO_DEPTH);
        empty <= (count == 0);
    end
end

endmodule