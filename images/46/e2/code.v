module fifo_buffer#(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wire clk,
    input wire rst,
    input wire enq,
    input wire deq,
    input wire [WIDTH-1:0] data_in,
    output wire [WIDTH-1:0] data_out,
    output wire full,
    output wire empty
);

reg [WIDTH-1:0] fifo_mem [DEPTH-1:0];
reg [4:0] head;
reg [4:0] tail;
reg [4:0] count;

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        head <= 0;
        tail <= 0;
        count <= 0;
    end else begin
        if (enq && !full) begin
            fifo_mem[tail] <= data_in;
            tail <= (tail + 1) % DEPTH;
            count <= count + 1;
        end
        if (deq && !empty) begin
            head <= (head + 1) % DEPTH;
            count <= count - 1;
        end
    end
end

assign data_out = fifo_mem[head];
assign full = (count == DEPTH);
assign empty = (count == 0);

endmodule