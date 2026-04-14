module top_module(
    input clk,
    input rst,
    input we,
    input din,
    output reg re,
    output reg [31:0] dout
);parameter WIDTH = 32;
    parameter DEPTH = 8;

    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [2:0] head = 3'b0;
    reg [2:0] tail = 3'b0;
    reg full = 1'b0;
    reg empty = 1'b1;

    always @(posedge clk) begin
        if (rst) begin
            head <= 3'b0;
            tail <= 3'b0;
            full <= 1'b0;
            empty <= 1'b1;
        end else begin
            if (we && !full) begin
                mem[head] <= din;
                head <= head + 1;
                if (head == tail) begin
                    full <= 1'b1;
                end
                empty <= 1'b0;
            end

            if (re && !empty) begin
                dout <= mem[tail];
                tail <= tail + 1;
                if (tail == head) begin
                    empty <= 1'b1;
                end
                full <= 1'b0;
            end
        end
    end

endmodule