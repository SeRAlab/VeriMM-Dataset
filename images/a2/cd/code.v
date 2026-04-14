module decoder_4to16 (
    input enable,
    input [3:0] in,
    output reg [15:0] out
);

    always @(*) begin
        if (enable) begin
            out = 16'd0;
            out[in] = 1'b1;
        end else begin
            out = 16'd0;
        end
    end

endmodule