module linked_list_traversal(
    input clk,
    input reset,
    input [2:0] start_index, // 3-bit index for 5 nodes (0 to 4)
    output reg [7:0] current_value, // 8-bit data for node value
    output reg done // signal to indicate end of traversal
);
    reg [7:0] linked_list [0:4]; // memory for 5 nodes
    reg [2:0] index; // current index for traversal

    initial begin
        // Initialize linked list values
        linked_list[0] = 8'd10;
        linked_list[1] = 8'd20;
        linked_list[2] = 8'd30;
        linked_list[3] = 8'd40;
        linked_list[4] = 8'd50;
        done = 1'b0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            index <= 3'b000; // reset index to 0
            current_value <= 8'b0;
            done <= 1'b0;
        end else begin
            if (index < 5) begin
                current_value <= linked_list[index];
                index <= index + 1;
            end else begin
                done <= 1'b1; // end of traversal
            end
        end
    end
endmodule