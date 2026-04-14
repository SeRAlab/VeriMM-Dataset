module top_module(
    input rd,
    input wr,
    input [7:0] din,
    output [7:0] dout,
    output empty,
    output full,
    input clock,
    input reset
);reg [7:0] mem [0:15];
reg [3:0] head;
reg [3:0] tail;
reg full_reg;
reg empty_reg;

assign dout = mem[tail];

always @(posedge clock) begin
    if (reset) begin
        head <= 0;
        tail <= 0;
        full_reg <= 0;
        empty_reg <= 1;
    end else begin
        if (wr && !full_reg) begin
            mem[head] <= din;
            head <= (head == 15) ? 0 : head + 1;
            empty_reg <= 0;
            if (head == tail) begin
                full_reg <= 1;
            end
        end
        if (rd && !empty_reg) begin
            tail <= (tail == 15) ? 0 : tail + 1;
            full_reg <= 0;
            if (tail == head) begin
                empty_reg <= 1;
            end
        end
    end
end

assign empty = empty_reg;
assign full = full_reg;

endmodule