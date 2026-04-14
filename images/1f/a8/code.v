module NVMe_FIFO (
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire [7:0] cmd_in,
    output reg [7:0] cmd_out,
    output reg empty,
    output reg full
);
    reg [7:0] fifo [3:0];
    reg [1:0] head, tail;
    reg [1:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 2'b00;
            tail <= 2'b00;
            count <= 2'b00;
            cmd_out <= 8'b0;
            empty <= 1'b1;
            full <= 1'b0;
        end else begin
            if (push && !full) begin
                fifo[head] <= cmd_in;
                head <= head + 1'b1;
                count <= count + 1'b1;
            end
            if (pop && !empty) begin
                cmd_out <= fifo[tail];
                tail <= tail + 1'b1;
                count <= count - 1'b1;
            end
            empty <= (count == 2'b00);
            full <= (count == 2'b10);
        end
    end
endmodule