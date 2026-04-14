module deadbeat_controller (
    input clk,
    input rst,
    input [7:0] setpoint,
    input [7:0] current_output,
    output reg [7:0] control_signal
);

    reg [7:0] error;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            control_signal <= 8'b0;
        end else begin
            error <= setpoint - current_output;
            control_signal <= error; // Simple deadbeat control logic (direct correction)
        end
    end
endmodule