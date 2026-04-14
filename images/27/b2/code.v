module linked_list_traversal(
    input clk,
    input reset,
    input start,
    output reg [7:0] current_data,
    output reg end_of_list
);

    reg [7:0] data [0:4]; // Example data for 5 nodes
    reg [3:0] next [0:4]; // Pointers to the next nodes
    reg [2:0] current_node;

    initial begin
        data[0] = 8'd10;
        data[1] = 8'd20;
        data[2] = 8'd30;
        data[3] = 8'd40;
        data[4] = 8'd50;

        next[0] = 4'd1; // Node 0 points to Node 1
        next[1] = 4'd2; // Node 1 points to Node 2
        next[2] = 4'd3; // Node 2 points to Node 3
        next[3] = 4'd4; // Node 3 points to Node 4
        next[4] = 4'd5; // Node 4 points to end (5)
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_node <= 3'd0; // Start from first node
            current_data <= 8'd0;
            end_of_list <= 1'b0;
        end else if (start) begin
            if (current_node < 4) begin
                current_data <= data[current_node];
                current_node <= next[current_node];
                end_of_list <= 1'b0;
            end else begin
                current_data <= 8'd0; // No data for end
                end_of_list <= 1'b1; // Reached end of list
            end
        end
    end

endmodule