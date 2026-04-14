module bst_insert(
    input [7:0] new_value,
    input [7:0] root,
    output reg [7:0] updated_root
);
    // Internal node representation
    reg [7:0] left_child;
    reg [7:0] right_child;

    always @(*) begin
        if (root == 0) begin
            updated_root = new_value; // If root is empty, set new value as root
        end else if (new_value < root) begin
            left_child = root - 1; // Move to left child
            updated_root = left_child; // Update root to left child
        end else begin
            right_child = root + 1; // Move to right child
            updated_root = right_child; // Update root to right child
        end
    end
endmodule