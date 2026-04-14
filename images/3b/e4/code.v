module switching_regulator (
    input clk,
    input [7:0] pwm_input,
    output reg [7:0] output_voltage
);
    always @(posedge clk) begin
        output_voltage <= pwm_input; // Directly assign PWM input to output voltage
    end
endmodule