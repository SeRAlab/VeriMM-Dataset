module linked_list_traversal(
    input clk,
    input reset,
    output reg [7:0] current_value,
    output reg done
);
    reg [7:0] list [0:4]; // Array to represent linked list
    reg [2:0] current_index; // Current index for traversal

    initial begin
        list[0] = 8'h01; // Node 1
        list[1] = 8'h02; // Node 2
        list[2] = 8'h03; // Node 3
        list[3] = 8'h04; // Node 4
        list[4] = 8'h05; // Node 5
        current_index = 3'b000; // Start from first node
        done = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_index <= 3'b000; // Reset to first node
            current_value <= 8'h00;
            done <= 0;
        end else begin
            if (current_index < 3'b101) begin
                current_value <= list[current_index];
                current_index <= current_index + 1;
            end else begin
                done <= 1; // Traversal complete
                current_value <= 8'h00; // No more values
            end
        end
    end
endmodule