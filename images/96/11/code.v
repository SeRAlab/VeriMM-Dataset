module decoder_4to16(
    input en,
    input [3:0] a,
    output reg [15:0] y
);
    always @(*) begin
        if (en) begin
            y = 16'b0;
            y[a] = 1'b1;
        end else begin
            y = 16'b0;
        end
    end
endmodule