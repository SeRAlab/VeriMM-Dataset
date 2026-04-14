module nvme_cmd_queue (
    input clk,
    input rst_n,
    input enqueue,
    input dequeue,
    input [7:0] cmd_in,
    output reg [7:0] cmd_out,
    output reg full,
    output reg empty,
    output reg [3:0] cmd_count
);
    reg [7:0] queue [0:15]; // Command queue with 16 depth
    reg [3:0] head;
    reg [3:0] tail;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            head <= 0;
            tail <= 0;
            cmd_count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (enqueue && !full) begin
                queue[tail] <= cmd_in;
                tail <= (tail + 1) % 16;
                cmd_count <= cmd_count + 1;
                empty <= 0;
                if (cmd_count == 15) full <= 1;
            end
            
            if (dequeue && !empty) begin
                cmd_out <= queue[head];
                head <= (head + 1) % 16;
                cmd_count <= cmd_count - 1;
                full <= 0;
                if (cmd_count == 1) empty <= 1;
            end
        end
    end
endmodule