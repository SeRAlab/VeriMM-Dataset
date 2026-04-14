module linked_list_traversal(
    input clk,
    input reset,
    input start,
    output reg [7:0] current_value
);
    parameter LIST_SIZE = 5;
    reg [7:0] linked_list [0:LIST_SIZE-1];
    reg [2:0] index; // 3-bit index for 0 to 4

    initial begin
        linked_list[0] = 8'h01; // Value at node 0
        linked_list[1] = 8'h02; // Value at node 1
        linked_list[2] = 8'h03; // Value at node 2
        linked_list[3] = 8'h04; // Value at node 3
        linked_list[4] = 8'h05; // Value at node 4
        index = 3'b000; // Start at the first node
        current_value = 8'h00; // Default output
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            index <= 3'b000;
            current_value <= 8'h00;
        end else if (start) begin
            if (index < LIST_SIZE) begin
                current_value <= linked_list[index];
                index <= index + 1;
            end
        end
    end
endmodule