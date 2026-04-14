module buck_converter(
    input wire clk,
    input wire rst,
    input wire [7:0] Vin,
    input wire [7:0] Vref,
    output reg PWM_out
);

reg [7:0] Vout;
reg [7:0] duty_cycle;
reg [7:0] error;
reg [7:0] previous_error;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        PWM_out <= 0;
        Vout <= 0;
        duty_cycle <= 0;
        previous_error <= 0;
    end else begin
        Vout <= Vin; // Ideally, this would be determined by the PWM signal in practice
        error <= Vref - Vout;

        // Simple PI controller
        duty_cycle <= duty_cycle + (error - previous_error);
        previous_error <= error;

        // PWM signal generation
        if (duty_cycle >= 8'd255) begin
            PWM_out <= 1;
            duty_cycle <= 8'd255;
        end else if (duty_cycle <= 8'd0) begin
            PWM_out <= 0;
            duty_cycle <= 8'd0;
        end else begin
            PWM_out <= (duty_cycle > 8'd127) ? 1 : 0; // Example threshold for PWM
        end
    end
end

endmodule