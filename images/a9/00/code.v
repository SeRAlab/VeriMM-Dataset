module top_module(
    input clk,
    input rst_,
    output reg [2:0] state_r
);// Define the states as enumerated types
    parameter [2:0] IDLE = 3'b000;
    parameter [2:0] SEND = 3'b001;
    parameter [2:0] WAIT1 = 3'b010;
    parameter [2:0] UPDATE1 = 3'b011;
    parameter [2:0] WAIT2 = 3'b100;
    parameter [2:0] UPDATE2 = 3'b101;

    // Define the next state variable
    reg [2:0] next_state;

    // Define the state transition logic
    always @(*) begin
        case (state_r)
            IDLE: next_state = SEND;
            SEND: next_state = WAIT1;
            WAIT1: next_state = UPDATE1;
            UPDATE1: next_state = WAIT2;
            WAIT2: next_state = UPDATE2;
            UPDATE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Define the state update logic
    always @(posedge clk or negedge rst_) begin
        if (~rst_) begin
            state_r <= IDLE;
        end else begin
            state_r <= next_state;
        end
    end

endmodule