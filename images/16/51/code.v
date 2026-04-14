module deadbeat_controller(
    input clk,
    input rst,
    input [3:0] current_state,
    input [3:0] desired_state,
    output reg [3:0] control_signal
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            control_signal <= 4'b0000;
        end else begin
            control_signal <= desired_state - current_state; // Simple deadbeat control
        end
    end
endmodule