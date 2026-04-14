module linked_list_traversal(
    input clk,
    input rst,
    input [7:0] node_value,
    input node_valid,
    output reg [7:0] output_value,
    output reg done
);
    parameter SIZE = 5; // Maximum number of nodes
    reg [7:0] nodes [0:SIZE-1];
    reg [2:0] current_index;
    reg [2:0] valid_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_index <= 0;
            valid_count <= 0;
            done <= 0;
            output_value <= 0;
        end else begin
            if (node_valid && valid_count < SIZE) begin
                nodes[valid_count] <= node_value;
                valid_count <= valid_count + 1;
            end
            
            if (current_index < valid_count) begin
                output_value <= nodes[current_index];
                current_index <= current_index + 1;
            end else begin
                done <= 1; // Traversal done
            end
        end
    end
endmodule