module motor_control(
    input clk,
    input direction,
    input [3:0] speed,
    output pwm
);

    reg [15:0] counter;
    reg pwm_out;

    always @(posedge clk) begin
        if (counter == 16'd999) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
        
        if (counter < speed) begin
            pwm_out <= 1;
        end else begin
            pwm_out <= 0;
        end
    end
    
    assign pwm = (direction == 1'b0) ? pwm_out : ~pwm_out;

endmodule