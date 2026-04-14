module mpc_controller (
    input [7:0] current_state,
    input [7:0] target_state,
    output reg [7:0] next_state
);
    always @(*) begin
        next_state = current_state + (target_state - current_state) >> 1; // Shift right for division by 2
    end
endmodule