module linked_list_traversal (
    input clk,
    input reset,
    input [7:0] head, // pointer to the head of the list
    output reg [7:0] current_value,
    output reg done
);
    reg [7:0] current_pointer;
    reg [7:0] memory [0:255]; // memory to hold linked list data

    initial begin
        // Initializing memory for the linked list for simulation purposes
        memory[0] = 8'd10; // Node 1
        memory[1] = 8'd20; // Node 2
        memory[2] = 8'd30; // Node 3
        memory[3] = 8'd40; // Node 4
        memory[4] = 8'd50; // Node 5
        memory[5] = 8'd0;   // End of list (null)
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_pointer <= head; // Start from head
            current_value <= 8'd0;
            done <= 1'b0;
        end else begin
            if (current_pointer != 8'd0) begin // While current pointer is not null
                current_value <= memory[current_pointer]; // Output current node value
                current_pointer <= current_pointer + 1; // Move to the next node
            end else begin
                done <= 1'b1; // Traversal is done
            end
        end
    end
endmodule