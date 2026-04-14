module deadbeat_controller(
    input clk,
    input reset,
    input [3:0] reference,
    input [3:0] current_state,
    output reg [3:0] control_signal
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 4'b0000;
        end else begin
            control_signal <= reference - current_state; // Deadbeat control
        end
    end
endmodule