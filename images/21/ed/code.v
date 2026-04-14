module mpc_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] reference,   // 4-bit reference input
    input wire [3:0] current_state, // 4-bit current state input
    output reg [3:0] control_signal // 4-bit control signal output
);

reg [3:0] error;
reg [3:0] predicted_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        control_signal <= 4'b0000;
        predicted_state <= 4'b0000;
    end else begin
        error <= reference - current_state; // Calculate error
        predicted_state <= current_state + (error >> 1); // Predict next state
        control_signal <= predicted_state; // Update control signal
    end
end

endmodule