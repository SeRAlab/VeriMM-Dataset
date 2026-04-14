module top_module(
    input wire clk,
    input wire rstn,
    input wire [15:0] note,
    output reg pwm_out
);wire clk_tmp;
    reg [15:0] divcounter = 0;

    // Counter to divide the clock frequency by the value of `note`
    always @(posedge clk)
        if (rstn == 0) begin
            divcounter <= 0;
        end else if (note == 0) begin
            divcounter <= 0;
        end else if (divcounter == note - 1) begin
            divcounter <= 0;
        end else begin
            divcounter <= divcounter + 1;
        end

    // Generate a pulse with a width of one clock cycle when the counter reaches 0
    assign clk_tmp = (divcounter == 0) ? 1 : 0;

    // Generate the PWM signal with a 50% duty cycle
    always @(posedge clk)
        if (rstn == 0) begin
            pwm_out <= 0;
        end else if (note == 0) begin
            pwm_out <= 0;
        end else if (clk_tmp == 1) begin
            pwm_out <= ~pwm_out;
        end

endmodule