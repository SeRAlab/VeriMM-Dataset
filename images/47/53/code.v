module top_module(
    input [3:0] in_signal,
    output reg [1:0] out_signal
);always @*
begin
    case(in_signal)
        4'b0000: out_signal = 2'b00;
        4'b0001: out_signal = 2'b01;
        4'b0010: out_signal = 2'b01;
        4'b0011: out_signal = 2'b01;
        4'b0100: out_signal = 2'b01;
        4'b0101: out_signal = 2'b10;
        4'b0110: out_signal = 2'b10;
        4'b0111: out_signal = 2'b10;
        4'b1000: out_signal = 2'b00;
        4'b1001: out_signal = 2'b01;
        4'b1010: out_signal = 2'b01;
        4'b1011: out_signal = 2'b01;
        4'b1100: out_signal = 2'b01;
        4'b1101: out_signal = 2'b10;
        4'b1110: out_signal = 2'b10;
        4'b1111: out_signal = 2'b10;
    endcase
end

endmodule