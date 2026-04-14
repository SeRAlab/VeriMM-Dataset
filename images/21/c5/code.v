module state_machine (
    input clk,
    input reset,
    input [2:0] state_input,
    output reg [1:0] state_output
);
    reg [1:0] current_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= 2'b00; // Initial state
        end else begin
            if (state_input[0]) begin
                current_state <= (current_state + 1) % 4; // Transition to the next state
            end
        end
    end

    always @(*) begin
        state_output = current_state; // Output current state
    end
endmodule