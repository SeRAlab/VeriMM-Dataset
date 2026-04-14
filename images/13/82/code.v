module nvme_controller (
    input clk,
    input rst,
    input en,
    input [1:0] cmd, // 00: no operation, 01: read, 10: write
    output reg [1:0] status // 00: idle, 01: processing, 10: empty, 11: error
);

    reg [2:0] queue_count; // Track number of commands in the queue
    parameter QUEUE_SIZE = 3; // Max 3 commands

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            queue_count <= 3'b000;
            status <= 2'b00; // idle
        end 
        else if (en) begin
            if (cmd == 2'b01 || cmd == 2'b10) begin // Read or Write Command
                if (queue_count < QUEUE_SIZE) begin
                    queue_count <= queue_count + 1;
                    status <= 2'b01; // processing
                end 
                else begin
                    status <= 2'b11; // error: queue full
                end
            end 
            else begin
                if (queue_count > 0) begin
                    queue_count <= queue_count - 1;
                    if (queue_count == 1) 
                        status <= 2'b10; // empty after processing
                end 
            end
        end
    end
endmodule