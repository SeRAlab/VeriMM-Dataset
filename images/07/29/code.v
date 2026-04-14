module pwm_generator(
    input clk,
    input rst,
    input [3:0] duty_cycle,
    output reg pwm_out
);
    reg [3:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 4'b0000;
            pwm_out <= 0;
        end else begin
            if (counter < duty_cycle) begin
                pwm_out <= 1;
            end else begin
                pwm_out <= 0;
            end
            counter <= counter + 1;
            if (counter == 4'b1111) begin
                counter <= 4'b0000;
            end
        end
    end
endmodule