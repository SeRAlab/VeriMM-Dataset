module mpc_controller (
    input wire clk,
    input wire rst,
    input wire [15:0] setpoint,
    input wire [15:0] process_variable,
    output reg [15:0] control_output
);
    parameter P_GAIN = 16'd2;  // Proportional gain
    parameter I_GAIN = 16'd1;  // Integral gain

    reg [15:0] integral_term;
    reg [15:0] error;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            control_output <= 16'd0;
            integral_term <= 16'd0;
        end else begin
            error = setpoint - process_variable;
            integral_term <= integral_term + error; // Integrate error over time
            control_output <= control_output + (P_GAIN * error) + (I_GAIN * integral_term);
        end
    end
endmodule