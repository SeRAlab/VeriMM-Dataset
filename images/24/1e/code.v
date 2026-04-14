module nvme_command_queue (
    input wire clk,
    input wire rst,
    input wire enqueue,
    input wire dequeue,
    input wire [3:0] command_id,
    output reg [3:0] command_out,
    output reg full,
    output reg empty
);
    reg [3:0] queue [0:3]; // Queue to hold 4 commands
    reg [1:0] head; // Pointer for dequeue
    reg [1:0] tail; // Pointer for enqueue
    reg [2:0] count; // Number of commands in the queue

    initial begin
        head = 0;
        tail = 0;
        count = 0;
        full = 0;
        empty = 1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (enqueue && !full) begin
                queue[tail] <= command_id;
                tail <= (tail + 1) % 4;
                count <= count + 1;
                if (count == 3) full <= 1;
                empty <= 0;
            end
            
            if (dequeue && !empty) begin
                command_out <= queue[head];
                head <= (head + 1) % 4;
                count <= count - 1;
                if (count == 1) empty <= 1;
                full <= 0;
            end
        end
    end
endmodule