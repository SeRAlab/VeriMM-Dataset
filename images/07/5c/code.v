module linked_list_traversal(
    input wire clk,
    input wire reset,
    input wire [7:0] head_data,
    input wire head_valid,
    output reg [7:0] current_data,
    output reg end_of_list
);
    reg [7:0] current_node;
    reg [7:0] next_node;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_data <= 8'b0;
            end_of_list <= 1'b0;
            current_node <= head_data;
        end else begin
            if (head_valid) begin
                current_data <= current_node;
                if (current_node == 8'b0) begin // Assuming 0 indicates end of list
                    end_of_list <= 1'b1;
                end else begin
                    // Simulate getting the next node
                    next_node <= current_node + 1; // Increment for simplicity
                    current_node <= next_node;
                    end_of_list <= 1'b0;
                end
            end
        end
    end
endmodule