module top_module(
    input clk,
    input reset,
    input rd,
    input wr,
    input [7:0] din,
    output [7:0] dout,
    output empty,
    output full,
    output reg [3:0] count
);reg [7:0] mem [0:7];
reg [2:0] head, tail;
wire [2:0] next_tail;

assign empty = (count == 0);
assign full = (count == 8);
assign dout = mem[head];

always @(posedge clk) begin
    if (reset) begin
        head <= 0;
        tail <= 0;
        count <= 0;
    end else begin
        if (wr && !full) begin
            mem[tail] <= din;
            tail <= next_tail;
            count <= count + 1;
        end
        if (rd && !empty) begin
            head <= head + 1;
            count <= count - 1;
        end
    end
end

assign next_tail = (tail == 7) ? 0 : tail + 1;

endmodule