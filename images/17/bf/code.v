module fifo_queue (
    input wire clk,
    input wire reset,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] fifo [0:7];
    reg [2:0] head, tail, count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 3'b000;
            tail <= 3'b000;
            count <= 3'b000;
            full <= 1'b0;
            empty <= 1'b1;
        end else begin
            if (push && !full) begin
                fifo[tail] <= data_in;
                tail <= (tail + 1) % 8;
                count <= count + 1;
            end

            if (pop && !empty) begin
                data_out <= fifo[head];
                head <= (head + 1) % 8;
                count <= count - 1;
            end

            full <= (count == 3'b111);
            empty <= (count == 3'b000);
        end
    end
endmodule