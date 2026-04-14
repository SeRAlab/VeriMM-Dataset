module signal_converter(
    input [3:0] input_signal,
    output reg [1:0] output_signal
);

always @(*) begin
    if (input_signal < 4) begin
        output_signal = 2'b00;
    end else if (input_signal < 8) begin
        output_signal = 2'b01;
    end else if (input_signal < 12) begin
        output_signal = 2'b10;
    end else begin
        output_signal = 2'b11;
    end
end

endmodule