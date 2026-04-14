module deadbeat_controller (
    input wire clk,
    input wire [3:0] current_state,
    input wire [3:0] desired_state,
    output reg [3:0] control_signal
);
    always @(posedge clk) begin
        control_signal <= desired_state - current_state; // Compute control signal
    end
endmodule