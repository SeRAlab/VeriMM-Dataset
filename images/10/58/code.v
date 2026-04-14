module mpc_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] control_input, // Control input
    input wire [7:0] setpoint,       // Desired output
    output reg [7:0] output_signal    // Controlled output
);
    reg [7:0] previous_output; // Store previous output

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_signal <= 8'b0;
            previous_output <= 8'b0;
        end else begin
            // Simple MPC logic: minimize error and update output
            if (control_input < setpoint) begin
                output_signal <= previous_output + 1;
            end else if (control_input > setpoint) begin
                output_signal <= previous_output - 1;
            end else begin
                output_signal <= previous_output;
            end
            previous_output <= output_signal; // Update previous output
        end
    end
endmodule