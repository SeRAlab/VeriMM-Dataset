module five_bit_module(
    input clk,
    input reset,
    input [4:0] input_signal,
    output reg [4:0] output_signal
);

always @(posedge clk) begin
    if (reset) begin
        output_signal <= 0;
    end else begin
        if (input_signal == 0) begin
            output_signal <= 0;
        end else if (input_signal % 2 == 0) begin
            output_signal <= input_signal + 1;
        end else begin
            output_signal <= input_signal - 1;
        end
    end
end

endmodule