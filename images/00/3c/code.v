module gpio_controller (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [4:0] input_signal,
    output reg [4:0] output_signal
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        output_signal <= 5'b00000;
    end else if (enable) begin
        output_signal <= input_signal;
    end
end

endmodule