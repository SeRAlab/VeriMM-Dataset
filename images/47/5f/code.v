module decoder_1to2 (
    input bin_in,
    output reg [1:0] one_hot_out
);

    always @(*) begin
        case (bin_in)
            1'd0: one_hot_out = 2'b01;
            1'd1: one_hot_out = 2'b10;
            default: one_hot_out = 2'b00;
        endcase
    end
endmodule