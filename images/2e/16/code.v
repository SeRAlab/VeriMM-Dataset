module bfs_fsm (
    input clk,
    input reset,
    input [2:0] current_node, // 3-bit input for nodes (0-7)
    output reg [2:0] next_node // 3-bit output for the next node
);

    // State representation
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010,
              S3 = 3'b011, S4 = 3'b100, S5 = 3'b101,
              S6 = 3'b110, S7 = 3'b111;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_node <= 3'b000; // Start at node 0
        end else begin
            case (current_node)
                3'b000: next_node <= 3'b001; // From node 0 to 1
                3'b001: next_node <= 3'b010; // From node 1 to 2
                3'b010: next_node <= 3'b011; // From node 2 to 3
                3'b011: next_node <= 3'b100; // From node 3 to 4
                3'b100: next_node <= 3'b101; // From node 4 to 5
                3'b101: next_node <= 3'b110; // From node 5 to 6
                3'b110: next_node <= 3'b111; // From node 6 to 7
                3'b111: next_node <= 3'b000; // Cycles back to 0
                default: next_node <= 3'b000; // Default case
            endcase
        end
    end
endmodule