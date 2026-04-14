module deadbeat_controller (
    input clk,
    input rst,
    input [3:0] state,
    input [3:0] setpoint,
    output reg [3:0] control_output
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            control_output <= 4'b0000;
        end else begin
            control_output <= setpoint - state; // Deadbeat control logic
        end
    end
endmodule