module mpc_controller(
    input clk,
    input reset,
    input [7:0] current_state,
    input [7:0] setpoint,
    output reg [7:0] output_signal
);
    reg [7:0] error;
    reg [7:0] previous_output;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_signal <= 8'b0;
            previous_output <= 8'b0;
        end else begin
            error <= setpoint - current_state;
            output_signal <= previous_output + (error >> 1); // Proportional control
            previous_output <= output_signal;
        end
    end
endmodule