module top_module(
    input clock,
    input [31:0] data,
    input rdreq,
    input wrreq,
    output empty,
    output full,
    output reg [31:0] q
);reg [31:0] memory [0:1023];
reg [9:0] head = 0;
reg [9:0] tail = 0;
reg [9:0] count = 0;

assign empty = (count == 0);
assign full = (count == 1024);

always @(posedge clock) begin
    if (wrreq && !full) begin
        memory[head] <= data;
        head <= (head == 1023) ? 0 : head + 1;
        count <= count + 1;
    end
    if (rdreq && !empty) begin
        q <= memory[tail];
        tail <= (tail == 1023) ? 0 : tail + 1;
        count <= count - 1;
    end
end

endmodule