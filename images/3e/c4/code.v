module linked_list_traversal (
    input clk,
    input reset,
    input enable,
    input [7:0] new_data,
    input insert,
    output reg [7:0] out_data,
    output reg done
);
    parameter MAX_NODES = 10;

    reg [7:0] list [0:MAX_NODES-1];
    reg [3:0] head, tail;
    reg [3:0] current;

    initial begin
        head = 0;
        tail = 0;
        current = 0;
        done = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 0;
            tail <= 0;
            current <= 0;
            done <= 0;
        end else begin
            if (insert) begin
                if (tail < MAX_NODES) begin
                    list[tail] <= new_data;
                    tail <= tail + 1;
                end
            end
            if (enable) begin
                if (current < tail) begin
                    out_data <= list[current];
                    current <= current + 1;
                end else begin
                    done <= 1; // Traversal complete
                end
            end
        end
    end
endmodule