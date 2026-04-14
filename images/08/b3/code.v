module fifo_queue (
    input wire clk,
    input wire rst,
    input wire enqueue,
    input wire dequeue,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty
);
    reg [7:0] queue [0:7];
    reg [2:0] head, tail;
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 3'b0;
            tail <= 3'b0;
            count <= 4'b0;
            empty <= 1;
            data_out <= 8'b0;
        end else begin
            if (enqueue && (count < 8)) begin
                queue[tail] <= data_in;
                tail <= (tail + 1) % 8;
                count <= count + 1;
                empty <= 0;
            end
            
            if (dequeue && (count > 0)) begin
                data_out <= queue[head];
                head <= (head + 1) % 8;
                count <= count - 1;
                if (count == 1) empty <= 1;
            end
            
            if (count == 0) begin
                data_out <= 8'b0;
                empty <= 1;
            end
        end
    end
endmodule