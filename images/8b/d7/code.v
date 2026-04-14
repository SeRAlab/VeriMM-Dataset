module decoder_2to4 (
    input [1:0] bin_in,
    output reg [3:0] one_hot_out
);

    always @(*) begin
        case (bin_in)
            2'd0: one_hot_out = 4'b0001;
            2'd1: one_hot_out = 4'b0010;
            2'd2: one_hot_out = 4'b0100;
            2'd3: one_hot_out = 4'b1000;
            default: one_hot_out = 4'b0000;
        endcase
    end
endmodule