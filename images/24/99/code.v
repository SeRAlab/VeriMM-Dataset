module fifo_queue (
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);

    reg [7:0] fifo [3:0]; // 4 elements FIFO
    reg [1:0] head;
    reg [1:0] tail;
    reg [2:0] count; // to keep track of the number of elements in FIFO

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (push && !full) begin
                fifo[tail] <= data_in;
                tail <= (tail + 1) % 4;
                count <= count + 1;
                if (count == 3) full <= 1;
                empty <= 0;
            end
            
            if (pop && !empty) begin
                data_out <= fifo[head];
                head <= (head + 1) % 4;
                count <= count - 1;
                if (count == 1) empty <= 1;
                full <= 0;
            end
        end
    end
endmodule