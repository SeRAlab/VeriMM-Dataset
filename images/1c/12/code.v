module deadbeat_controller (
    input clk,
    input rst_n,
    input [3:0] current_state,
    input [3:0] desired_state,
    output reg [3:0] control_signal
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            control_signal <= 4'b0000;
        end else begin
            control_signal <= desired_state - current_state; // Deadbeat control logic
        end
    end
endmodule