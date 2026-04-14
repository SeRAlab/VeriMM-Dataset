module decoder_4to16 (
    input [3:0] bin_in,
    output reg [15:0] one_hot_out
);

    always @(*) begin
        case (bin_in)
            4'd0: one_hot_out = 16'b0000000000000001;
            4'd1: one_hot_out = 16'b0000000000000010;
            4'd2: one_hot_out = 16'b0000000000000100;
            4'd3: one_hot_out = 16'b0000000000001000;
            4'd4: one_hot_out = 16'b0000000000010000;
            4'd5: one_hot_out = 16'b0000000000100000;
            4'd6: one_hot_out = 16'b0000000001000000;
            4'd7: one_hot_out = 16'b0000000010000000;
            4'd8: one_hot_out = 16'b0000000100000000;
            4'd9: one_hot_out = 16'b0000001000000000;
            4'd10: one_hot_out = 16'b0000010000000000;
            4'd11: one_hot_out = 16'b0000100000000000;
            4'd12: one_hot_out = 16'b0001000000000000;
            4'd13: one_hot_out = 16'b0010000000000000;
            4'd14: one_hot_out = 16'b0100000000000000;
            4'd15: one_hot_out = 16'b1000000000000000;
            default: one_hot_out = 16'b0000000000000000;
        endcase
    end
endmodule