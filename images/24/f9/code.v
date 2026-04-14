module gpio_controller (
    input wire [3:0] gpio_input,
    input wire control,
    output reg [3:0] gpio_output
);

always @(posedge control) begin
    if (control) begin
        gpio_output <= gpio_input;
    end else begin
        gpio_output <= 4'b0000;
    end
end

endmodule