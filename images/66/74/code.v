module top_module(
    input clk_i,
    input rst_i,
    input [g_width-1:0] data_i,
    input push_i,
    input pull_i,
    output [g_width-1:0] data_o,
    output full_o,
    output empty_o
);parameter g_width = 32;

    reg [g_width-1:0] mem [0:15];
    reg [3:0] head;
    reg [3:0] tail;
    wire [3:0] next_head;
    wire [3:0] next_tail;
    reg full;
    reg empty;

    assign next_head = (head == 15) ? 0 : head + 1;
    assign next_tail = (tail == 15) ? 0 : tail + 1;

    always @(posedge clk_i, negedge rst_i) begin
        if (!rst_i) begin
            head <= 0;
            tail <= 0;
            empty <= 1;
            full <= 0;
        end else begin
            if (push_i && !full) begin
                mem[head] <= data_i;
                head <= next_head;
                empty <= 0;
                if (next_head == tail) begin
                    full <= 1;
                end
            end
            if (pull_i && !empty) begin
                tail <= next_tail;
                full <= 0;
                if (next_tail == head) begin
                    empty <= 1;
                end
            end
        end
    end

    assign data_o = mem[tail];
    assign full_o = full;
    assign empty_o = empty;

endmodule