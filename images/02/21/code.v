module linked_list_traversal (
    input wire clk,
    input wire reset,
    input wire start,
    output reg [7:0] data_out,
    output reg done
);
    reg [3:0] current_index;
    reg [7:0] linked_list [0:15]; // Array representing linked list data
    reg [3:0] next_index [0:15]; // Array representing next pointers

    initial begin
        // Example initialization
        linked_list[0] = 8'h01; next_index[0] = 4'h1;
        linked_list[1] = 8'h02; next_index[1] = 4'h2;
        linked_list[2] = 8'h03; next_index[2] = 4'h3;
        linked_list[3] = 8'h04; next_index[3] = 4'hF; // End of list
        // Remaining elements can be initialized as needed
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_index <= 4'h0;
            data_out <= 8'h00;
            done <= 1'b0;
        end else if (start) begin
            if (current_index < 4'hF) begin
                data_out <= linked_list[current_index];
                current_index <= next_index[current_index];
            end else begin
                data_out <= 8'h00; // Reset output at end of list
                done <= 1'b1; // Indicate traversal is done
            end
        end
    end
endmodule