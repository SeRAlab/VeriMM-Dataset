module gpio_controller (
    input [2:0] mode,
    input gpio_state,
    output reg gpio_output
);

always @(*) begin
    if (mode == 3'b101 && gpio_state == 1) begin
        gpio_output = 1;
    end else begin
        gpio_output = 0;
    end
end

endmodule