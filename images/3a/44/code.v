module gpio_controller(
    input wire clk,
    input wire set,
    input wire clear,
    output reg gpio_out
);

always @(posedge clk) begin
    if (set) begin
        gpio_out <= 1'b1;
    end else if (clear) begin
        gpio_out <= 1'b0;
    end
end

endmodule