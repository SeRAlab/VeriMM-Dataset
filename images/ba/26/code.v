module top_module(
    input [3:0] in_signal,
    output reg [1:0] out_signal
);always @(*) begin
    case(in_signal)
        4'd0: out_signal = 2'b00;
        4'd1: out_signal = 2'b00;
        4'd2: out_signal = 2'b00;
        4'd3: out_signal = 2'b00;
        4'd4: out_signal = 2'b01;
        4'd5: out_signal = 2'b01;
        4'd6: out_signal = 2'b01;
        4'd7: out_signal = 2'b01;
        4'd8: out_signal = 2'b10;
        4'd9: out_signal = 2'b10;
        4'd10: out_signal = 2'b10;
        default: out_signal = 2'b11;
    endcase
end

endmodule