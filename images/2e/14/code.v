module linked_list_traversal (
    input wire clk,
    input wire start,
    output reg [3:0] current_node
);

    reg [3:0] list [0:3]; // array to hold 4 nodes
    reg [1:0] index;      // index to track current node

    initial begin
        list[0] = 4'b0001; // Node 1
        list[1] = 4'b0010; // Node 2
        list[2] = 4'b0011; // Node 3
        list[3] = 4'b0100; // Node 4
        index = 2'b00;     // start at first node
        current_node = list[0];
    end

    always @(posedge clk) begin
        if (start) begin
            if (index < 2'b11) begin
                index <= index + 1;
                current_node <= list[index + 1];
            end
            else begin
                index <= 2'b00; // Reset to first node
                current_node <= list[0];
            end
        end
    end
endmodule