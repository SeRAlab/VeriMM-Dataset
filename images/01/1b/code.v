module deadbeat_controller(
    input clk,
    input reset,
    input [3:0] desired_input,
    output reg [3:0] output_signal
);
    reg [1:0] state;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_signal <= 4'b0000;
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin
                    output_signal <= desired_input; // Set output to desired input immediately
                    state <= 2'b01; // Move to the next state
                end
                2'b01: begin
                    // Final state, can hold or perform any additional logic here
                    state <= 2'b10; // Move to a final state
                end
                2'b10: begin
                    // No further actions, maintain the last output
                    state <= 2'b10; // Stay in same state
                end
                default: state <= 2'b00;
            endcase
        end
    end
endmodule