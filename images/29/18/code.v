module mpc_controller (
    input [4:0] current_state,
    input [4:0] input_signal,
    input [2:0] scale_factor,
    output reg [4:0] next_state
);

always @(current_state or input_signal or scale_factor) begin
    next_state = current_state + (input_signal * scale_factor);
end

endmodule