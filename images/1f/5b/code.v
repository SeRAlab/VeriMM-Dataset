module state_space_controller(
    input [2:0] current_state,
    input control_signal,
    output reg [2:0] next_state
);
    always @(current_state or control_signal) begin
        if (control_signal == 1) begin
            next_state = current_state + 1;
            if (next_state == 3'b1000) begin
                next_state = 3'b000; // Wrap around for 3-bit state
            end
        end else begin
            next_state = current_state; // Stay in the same state
        end
    end
endmodule