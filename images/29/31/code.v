module linked_list_traversal(
    input clk,
    input rst,
    output reg [7:0] data_out,
    output reg done
);

    reg [7:0] linked_list [0:4]; // A simple linked list of 5 elements
    reg [2:0] current_index; // 3 bits to address 5 elements (0-4)
    reg [2:0] next_index;

    initial begin
        linked_list[0] = 8'h01; // Initialize linked list values
        linked_list[1] = 8'h02;
        linked_list[2] = 8'h03;
        linked_list[3] = 8'h04;
        linked_list[4] = 8'h05;
        current_index = 3'b000; // Start at the first element
        done = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_index <= 3'b000; // Reset to the first element
            done <= 0;
        end else if (current_index < 3'b101) begin
            data_out <= linked_list[current_index]; // Output current node value
            current_index <= current_index + 1; // Move to the next node
        end else begin
            done <= 1; // Indicate traversal is done
        end
    end
endmodule