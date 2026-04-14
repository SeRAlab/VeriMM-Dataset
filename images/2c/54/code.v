module linked_list_traversal (
    input clk,
    input reset,
    input [3:0] head_index,
    output reg [7:0] current_data,
    output reg done
);
    reg [7:0] linked_list [0:15]; // A simple linked list with 16 nodes, each node contains 8-bit data
    reg [3:0] current_index;

    initial begin
        // Initializing linked list with some values
        linked_list[0] = 8'h1A;
        linked_list[1] = 8'h2B;
        linked_list[2] = 8'h3C;
        linked_list[3] = 8'h4D;
        linked_list[4] = 8'h5E;
        linked_list[5] = 8'h6F;
        linked_list[6] = 8'h7A;
        linked_list[7] = 8'h8B;
        linked_list[8] = 8'h9C;
        linked_list[9] = 8'hAD;
        linked_list[10] = 8'hBE;
        linked_list[11] = 8'hCF;
        linked_list[12] = 8'hDA;
        linked_list[13] = 8'hEB;
        linked_list[14] = 8'hFC;
        linked_list[15] = 8'h0D;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_index <= head_index;
            current_data <= 0;
            done <= 0;
        end else if (current_index < 16) begin
            current_data <= linked_list[current_index];
            current_index <= current_index + 1;
            done <= (current_index == 15) ? 1 : 0;
        end else begin
            done <= 1; // End of list reached
        end
    end
endmodule