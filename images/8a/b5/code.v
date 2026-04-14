module top_module(
    input clk,
    input rst,
    input we,
    input [7:0] din,
    output reg re,
    output reg [7:0] dout
);reg [7:0] mem [15:0];
reg [3:0] head;
reg [3:0] tail;
reg full;

always @(posedge clk) begin
    if (rst) begin
        head <= 0;
        tail <= 0;
        full <= 0;
    end else if (we && !full) begin
        mem[head] <= din;
        head <= head + 1;
        if (head == 16) begin
            head <= 0;
        end
        if (head == tail) begin
            full <= 1;
        end
    end else if (re && !full) begin
        dout <= mem[tail];
        tail <= tail + 1;
        if (tail == 16) begin
            tail <= 0;
        end
        if (tail == head) begin
            re <= 0;
        end
    end
end

always @(posedge clk) begin
    if (we && full) begin
        re <= 1;
    end else if (re && !full) begin
        re <= 1;
    end
end

endmodule