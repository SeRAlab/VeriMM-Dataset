module fifo_queue (
    input wire clk,
    input wire reset,
    input wire enqueue,
    input wire dequeue,
    input wire [3:0] data_in,
    output reg [3:0] data_out,
    output reg full,
    output reg empty
);

    reg [3:0] fifo [0:7]; // 8 entries of 4 bits each
    reg [2:0] head;       // points to the head of the FIFO
    reg [2:0] tail;       // points to the tail of the FIFO
    reg [3:0] count;      // number of items in the FIFO

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 3'b000;
            tail <= 3'b000;
            count <= 4'b0000;
            full <= 1'b0;
            empty <= 1'b1;
            data_out <= 4'b0000;
        end else begin
            if (enqueue && ~full) begin
                fifo[tail] <= data_in;
                tail <= (tail + 1) % 8;
                count <= count + 1;
            end
            
            if (dequeue && ~empty) begin
                data_out <= fifo[head];
                head <= (head + 1) % 8;
                count <= count - 1;
            end
            
            full <= (count == 4'b1000);
            empty <= (count == 4'b0000);
        end
    end
endmodule