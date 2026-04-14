module state_machine (
    input wire clk,
    input wire reset,
    input wire data,
    output reg state
);
    // State definitions
    parameter S0 = 1'b0;
    parameter S1 = 1'b1;

    // State register
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            state <= S0; // Reset to state S0
        end else begin
            case (state)
                S0: if (data) state <= S1; // Transition to S1
                S1: if (!data) state <= S0; // Transition to S0
                default: state <= S0; // Default case
            endcase
        end
    end
endmodule