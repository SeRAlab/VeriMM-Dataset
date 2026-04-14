module rrt_tree (
    input wire clk,
    input wire reset,
    input wire [4:0] random_point,
    input wire [4:0] current_point,
    input wire start,
    output reg [4:0] parent,
    output reg [4:0] child,
    output reg done
);
    reg [2:0] state;
    reg [2:0] next_state;
    parameter IDLE = 3'b000, EXPAND = 3'b001, CONNECT = 3'b010, DONE = 3'b011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (start) begin
                    next_state = EXPAND;
                end else begin
                    next_state = IDLE;
                end
            end
            EXPAND: begin
                // Simple expansion logic (for the sake of the example)
                parent = current_point;
                child = random_point; // In practice, apply distance checks
                next_state = CONNECT;
            end
            CONNECT: begin
                // Logic to connect points could be added here
                done = 1;
                next_state = DONE;
            end
            DONE: begin
                done = 1; // Remain in DONE state
                next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule