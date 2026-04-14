module mpc_controller (
    input clk,
    input rst,
    input [7:0] setpoint,
    input [7:0] process_variable,
    output reg [7:0] control_output
);
    parameter K = 8'd2; // Proportional gain

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            control_output <= 8'b0;
        end else begin
            control_output <= setpoint - process_variable; // Calculate error
            control_output <= control_output * K; // Apply gain
        end
    end
endmodule