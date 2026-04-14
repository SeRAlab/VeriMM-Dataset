module bfs_fsm (
    input clk,
    input rst,
    input [3:0] current_node,
    output reg [3:0] next_node
);

    reg [2:0] state;
    parameter IDLE = 3'b000, LOAD = 3'b001, VISIT = 3'b010, DONE = 3'b011;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            next_node <= 4'b0000;
        end else begin
            case (state)
                IDLE: begin
                    if (current_node < 4) begin
                        state <= LOAD;
                    end
                end
                LOAD: begin
                    next_node <= current_node; // Load current node
                    state <= VISIT;
                end
                VISIT: begin
                    case (current_node)
                        4'b0000: next_node <= 4'b0001; // Node 0 visits Node 1
                        4'b0001: next_node <= 4'b0010; // Node 1 visits Node 2
                        4'b0010: next_node <= 4'b0011; // Node 2 visits Node 3
                        4'b0011: next_node <= 4'b0100; // Node 3 visits Node 4
                        4'b0100: next_node <= 4'bxxxx; // Node 4 has no next node
                        default: next_node <= 4'bxxxx; // Undefined state
                    endcase
                    state <= DONE;
                end
                DONE: begin
                    state <= IDLE; // Reset to IDLE for the next input
                end
            endcase
        end
    end
endmodule