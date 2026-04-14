module bfs_fsm(
    input wire clk,
    input wire reset,
    input wire [3:0] current_node,
    output reg [3:0] next_node
);
    reg [3:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 4'b0000; // Initial state
            next_node <= 4'b0000;
        end else begin
            case (state)
                4'b0000: begin // Node 0
                    next_node <= 4'b0001; // Next node 1
                    state <= 4'b0001;
                end
                4'b0001: begin // Node 1
                    next_node <= 4'b0010; // Next node 2
                    state <= 4'b0010;
                end
                4'b0010: begin // Node 2
                    next_node <= 4'b0011; // Next node 3
                    state <= 4'b0011;
                end
                4'b0011: begin // Node 3
                    next_node <= 4'b0100; // Next node 4
                    state <= 4'b0100;
                end
                4'b0100: begin // Node 4
                    next_node <= 4'b0000; // Loop back to start
                    state <= 4'b0000;
                end
                default: begin
                    next_node <= 4'b0000;
                    state <= 4'b0000;
                end
            endcase
        end
    end
endmodule