module fifo_queue (
    input wire clk,
    input wire reset,
    input wire enqueue,
    input wire dequeue,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);
    reg [7:0] queue [0:3];
    reg [1:0] head, tail, count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 2'b00;
            tail <= 2'b00;
            count <= 2'b00;
            empty <= 1'b1;
            full <= 1'b0;
            data_out <= 8'b0;
        end else begin
            if (enqueue && !full) begin
                queue[tail] <= data_in;
                tail <= (tail + 1) % 4;
                count <= count + 1;
                empty <= 1'b0;
                if (count == 2'b11) full <= 1'b1;
            end

            if (dequeue && !empty) begin
                data_out <= queue[head];
                head <= (head + 1) % 4;
                count <= count - 1;
                full <= 1'b0;
                if (count == 2'b01) empty <= 1'b1;
            end
        end
    end
endmodule