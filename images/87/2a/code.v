module top_module(
    input [3:0] input_signal,
    output reg [2:0] output_signal
);always @(*) begin
    if(input_signal <= 4) begin
        output_signal = input_signal - 1;
    end else begin
        output_signal = input_signal + 1;
    end
end

endmodule