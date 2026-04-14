module linked_list_traversal (
    input clk,
    input rst,
    input [7:0] data_in,
    input valid,
    output reg [7:0] data_out,
    output reg done
);
    parameter SIZE = 5;
    reg [7:0] list [0:SIZE-1];
    reg [2:0] current_node;
    reg initialized;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_node <= 0;
            done <= 0;
            initialized <= 0;
        end else if (valid && !initialized) begin
            list[current_node] <= data_in;
            if (current_node < SIZE-1) begin
                current_node <= current_node + 1;
            end else begin
                initialized <= 1;
                current_node <= 0; // Reset to the start for traversal
            end
        end else if (initialized) begin
            data_out <= list[current_node];
            if (current_node < SIZE-1) begin
                current_node <= current_node + 1;
            end else begin
                done <= 1; // Indicate traversal is done
            end
        end
    end
endmodule