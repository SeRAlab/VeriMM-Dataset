module decoder_2to4 (
    input [1:0] a,
    input en,
    output reg [3:0] y
);

    always @(*) begin
        if (en) begin
            y = 4'b0000;
            y[a] = 1;
        end else begin
            y = 4'b0000;
        end
    end

endmodule