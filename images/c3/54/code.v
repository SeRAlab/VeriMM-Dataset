module signal_converter(
    input [3:0] in_signal,
    output reg [2:0] out_signal
);

always @(*) begin
    if (in_signal < 4) begin
        out_signal = in_signal;
    end else if (in_signal < 8) begin
        out_signal = in_signal - 1;
    end else begin
        out_signal = in_signal - 2;
    end
end

endmodule