module LinkedListTraversal(
    input clk,
    input reset,
    input [7:0] head, // head pointer
    output reg [7:0] current_value,
    output reg done
);
    reg [7:0] memory [0:255]; // Memory to hold linked list
    reg [7:0] current_pointer;

    initial begin
        // Sample linked list initialization
        memory[0] = 8'h01; // Node 1 value
        memory[1] = 8'h02; // Node 2 value
        memory[2] = 8'h03; // Node 3 value
        memory[3] = 8'h00; // End of list (null pointer)
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_pointer <= head;
            current_value <= 8'h00;
            done <= 0;
        end else if (current_pointer != 8'h00) begin
            current_value <= memory[current_pointer]; // Read current node value
            current_pointer <= current_pointer + 1; // Move to next node
        end else begin
            done <= 1; // End of list
        end
    end
endmodule