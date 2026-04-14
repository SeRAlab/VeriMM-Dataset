module decoder_4to16 (
    input [3:0] a,
    output reg [15:0] y
);

    always @(*) begin
        y = 16'b0000000000000000;
        y[a] = 1;
    end

endmodule