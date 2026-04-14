module state_space_controller(
    input clk,
    input reset,
    input ctrl_signal,
    output reg [1:0] state
);

    // State encoding
    parameter STATE_0 = 2'b00;
    parameter STATE_1 = 2'b01;
    parameter STATE_2 = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_0; // Reset to initial state
        end else begin
            case (state)
                STATE_0: if (ctrl_signal) state <= STATE_1; // Transition to STATE_1
                STATE_1: if (~ctrl_signal) state <= STATE_2; // Transition to STATE_2
                STATE_2: state <= STATE_0; // Transition back to STATE_0
                default: state <= STATE_0; // Default to initial state
            endcase
        end
    end
endmodule