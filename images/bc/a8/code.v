module decoder_4to16 (
    input [3:0] a,
    input en,
    output reg [15:0] y
);

    // Decoder logic
    always @(*) begin
        if (en) begin
            y = 16'b0;
            y[a] = 1'b1;
        end else begin
            y = 16'b0;
        end
    end

endmodule