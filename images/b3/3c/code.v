module top_module(input [3:0] input_signal, output reg [1:0] output_signal);always @(*) begin
        case(input_signal)
            4'd0: output_signal = 2'b00;
            4'd1: output_signal = 2'b00;
            4'd2: output_signal = 2'b00;
            4'd3: output_signal = 2'b00;
            4'd4: output_signal = 2'b00;
            4'd5: output_signal = 2'b00;
            4'd6: output_signal = 2'b01;
            4'd7: output_signal = 2'b01;
            4'd8: output_signal = 2'b01;
            4'd9: output_signal = 2'b01;
            4'd10: output_signal = 2'b01;
            4'd11: output_signal = 2'b10;
            4'd12: output_signal = 2'b10;
            4'd13: output_signal = 2'b10;
            4'd14: output_signal = 2'b10;
            4'd15: output_signal = 2'b10;
            default: output_signal = 2'b11;
        endcase
    end

endmodule