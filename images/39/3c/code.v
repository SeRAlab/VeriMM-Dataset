module linked_list_traversal(
    input clk,
    input reset,
    input [7:0] add_element,
    input traverse,
    output reg [7:0] output_element
);
    reg [7:0] list [0:4]; // Array to hold up to 5 elements
    reg [2:0] count; // To keep track of the number of elements added
    reg [2:0] index; // To keep track of the current index during traversal

    // Reset condition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            index <= 0;
            output_element <= 8'b0;
        end else begin
            if (add_element != 8'b0 && count < 5) begin
                list[count] <= add_element; // Add element to the list
                count <= count + 1; // Increment count
            end

            if (traverse) begin
                if (index < count) begin
                    output_element <= list[index]; // Output the current element
                    index <= index + 1; // Move to the next element
                end else begin
                    output_element <= 8'b0; // No more elements to traverse
                end
            end
        end
    end
endmodule