module linked_list_traversal(
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire add_node,
    input wire traverse,
    output reg [7:0] current_data,
    output reg valid
);
    
    reg [7:0] list[0:4]; // array to hold 5 nodes
    reg [2:0] head; // points to the current node
    reg [2:0] tail; // points to the last node added
    reg [2:0] count; // count of nodes in the list

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            valid <= 0;
            current_data <= 8'b0;
        end else begin
            if (add_node && count < 5) begin
                list[tail] <= data_in; // add the node
                tail <= tail + 1;
                count <= count + 1;
                valid <= 1;
            end
            if (traverse && count > 0) begin
                current_data <= list[head]; // output current node's value
                head <= head + 1;
                valid <= 1;
            end else begin
                valid <= 0;
            end
        end
    end
endmodule