module gray_counter (
    input clk,
    input rst,
    output reg [1:0] gray_out
);
    reg [1:0] state, next_state;

    // State encoding for Gray code
    parameter S0 = 2'b00; // 00 in Gray
    parameter S1 = 2'b01; // 01 in Gray
    parameter S2 = 2'b11; // 10 in Gray
    parameter S3 = 2'b10; // 11 in Gray

    // State transition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S0; // Reset to state S0
        end else begin
            state <= next_state; // Move to next state
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S0;
            default: next_state = S0;
        endcase
    end

    // Output logic
    always @(state) begin
        gray_out = state; // Output is the current state
    end
endmodule