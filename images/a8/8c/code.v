module pwm_generator (
    input clk,
    input [7:0] duty_cycle,
    output pwm
);
    reg [7:0] counter;

    always @(posedge clk) begin
        counter <= counter + 1;
    end

    assign pwm = (counter < duty_cycle) ? 1 : 0;

endmodule