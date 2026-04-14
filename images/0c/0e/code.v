module nvme_command_scheduler(
    input wire clk,
    input wire rst,
    input wire [4:0] cmd_in,
    input wire cmd_valid,
    output reg [4:0] cmd_out,
    output reg cmd_processing
);
    reg [4:0] cmd_queue [0:4];
    reg [2:0] head;
    reg [2:0] tail;
    reg [2:0] count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 3'b0;
            tail <= 3'b0;
            count <= 3'b0;
            cmd_processing <= 1'b0;
            cmd_out <= 5'b00000;
        end else begin
            if (cmd_valid && count < 5) begin
                cmd_queue[tail] <= cmd_in;
                tail <= tail + 1;
                count <= count + 1;
            end
            if (count > 0) begin
                cmd_out <= cmd_queue[head];
                cmd_processing <= 1'b1;
                head <= head + 1;
                count <= count - 1;
            end else begin
                cmd_processing <= 1'b0;
            end
        end
    end
endmodule