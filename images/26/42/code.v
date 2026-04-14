module linked_list_traversal(
    input clk,
    input rst,
    input en,
    input [7:0] insert_value,
    input insert_en,
    output reg [7:0] current_value,
    output reg done
);
    reg [7:0] list [0:4]; // Fixed size array for linked list
    reg [2:0] head; // Index of the current node
    reg [2:0] size; // Current size of the list

    initial begin
        head = 3'b000; // Start at the first node
        size = 3'b000; // Start with an empty list
        done = 1'b0;
        current_value = 8'b0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 3'b000;
            size <= 3'b000;
            done <= 1'b0;
            current_value <= 8'b0;
        end else begin
            if (insert_en && size < 5) begin
                list[size] <= insert_value; // Insert value at the end
                size <= size + 1;
            end
            
            if (en) begin
                if (head < size) begin
                    current_value <= list[head]; // Output the current node value
                    head <= head + 1; // Move to the next node
                    done <= (head == size); // Check if done traversing
                end else begin
                    done <= 1'b1; // Traversal done
                end
            end
        end
    end
endmodule