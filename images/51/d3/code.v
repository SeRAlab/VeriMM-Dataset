module decoder_3to8 (
    input [2:0] bin_in,
    output reg [7:0] one_hot_out
);

    always @(*) begin
        case (bin_in)
            3'd0: one_hot_out = 8'b00000001;
            3'd1: one_hot_out = 8'b00000010;
            3'd2: one_hot_out = 8'b00000100;
            3'd3: one_hot_out = 8'b00001000;
            3'd4: one_hot_out = 8'b00010000;
            3'd5: one_hot_out = 8'b00100000;
            3'd6: one_hot_out = 8'b01000000;
            3'd7: one_hot_out = 8'b10000000;
            default: one_hot_out = 8'b00000000;
        endcase
    end
endmodule