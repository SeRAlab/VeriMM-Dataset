module top_module(
    input [15:0] input_signal,
    output reg [1:0] output_signal
);always @(*) begin
    if (input_signal < 1000) begin
        output_signal = 2'b01;
    end else if (input_signal >= 1000 && input_signal <= 2000) begin
        output_signal = 2'b10;
    end else if (input_signal > 2000) begin
        output_signal = 2'b11;
    end
end

endmodule