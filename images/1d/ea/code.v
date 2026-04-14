module fifo_queue (
    input clk,
    input reset,
    input push,
    input pop,
    input [3:0] data_in,
    output reg [3:0] data_out,
    output reg empty
);
    reg [3:0] queue [0:3]; // FIFO storage for 4 elements
    reg [1:0] head, tail, count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 2'b00;
            tail <= 2'b00;
            count <= 2'b00;
            empty <= 1;
            data_out <= 4'b0000;
        end else begin
            if (push && (count < 4)) begin
                queue[tail] <= data_in;
                tail <= tail + 1;
                count <= count + 1;
                empty <= 0;
            end
            if (pop && (count > 0)) begin
                data_out <= queue[head];
                head <= head + 1;
                count <= count - 1;
                if (count == 1) begin
                    empty <= 1;
                end
            end
        end
    end
endmodule