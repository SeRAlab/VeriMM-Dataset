module linked_list_traversal(
    input [2:0] index,
    output reg [7:0] value
);
    reg [7:0] linked_list [0:4];

    initial begin
        linked_list[0] = 8'h01; // Node 0 value
        linked_list[1] = 8'h02; // Node 1 value
        linked_list[2] = 8'h03; // Node 2 value
        linked_list[3] = 8'h04; // Node 3 value
        linked_list[4] = 8'h05; // Node 4 value
    end

    always @(*) begin
        if (index < 5)
            value = linked_list[index];
        else
            value = 8'h00; // Default value if index is out of range
    end
endmodule