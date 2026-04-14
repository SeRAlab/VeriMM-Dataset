module switching_regulator (
    input wire clk,
    input wire reset,
    input wire [7:0] Vin,
    input wire [7:0] Vref,
    output reg [7:0] Vout,
    output reg [7:0] D,
    output reg pwm_out
);
    reg [7:0] error;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Vout <= 8'd0;
            D <= 8'd0;
            pwm_out <= 1'b0;
        end else begin
            // Calculate error
            error <= Vref - Vout;
            
            // Adjust duty cycle based on error
            D <= D + (error >> 1); // Proportional control, simple
            
            // Limit duty cycle to 0-255
            if (D > 8'd255) D <= 8'd255;
            else if (D < 8'd0) D <= 8'd0;
            
            // Generate Vout based on Vin and duty cycle
            Vout <= (Vin * D) >> 8;
            
            // PWM output generation
            pwm_out <= (counter < D) ? 1'b1 : 1'b0;
        end
    end
    
    reg [7:0] counter = 8'd0; // Counter for PWM
    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter >= 8'd255) counter <= 8'd0; // Reset counter every 256 cycles
    end
endmodule