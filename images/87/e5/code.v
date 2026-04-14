module top_module(
    input clk,
    input rst,
    input [15:0] duty_cycle,
    output pwm_out
);reg [15:0] counter;
reg pwm_out_reg;

always @(posedge clk) begin
    if (rst) begin
        counter <= 0;
        pwm_out_reg <= 0;
    end else begin
        counter <= counter + 1;
        if (counter >= duty_cycle) begin
            pwm_out_reg <= 1;
        end else begin
            pwm_out_reg <= 0;
        end
        if (counter == 65535) begin
            counter <= 0;
        end
    end
end

assign pwm_out = pwm_out_reg;

endmodule