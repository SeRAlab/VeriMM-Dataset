module pwm_generator(
    input wire clk,
    input wire [7:0] duty_cycle, // 0 to 100
    output reg pwm_out
);
    reg [7:0] counter;

    always @(posedge clk) begin
        if (counter < duty_cycle)
            pwm_out <= 1'b1;
        else
            pwm_out <= 1'b0;

        counter <= (counter + 1) % 100; // Reset counter after reaching 100
    end
endmodule