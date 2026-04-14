module top_module(
    input [31:0] in_signal,
    input [15:0] const_value,
    output reg [15:0] out_signal
);always @ (*) begin
    out_signal = in_signal[15:0] & const_value;
end

endmodule