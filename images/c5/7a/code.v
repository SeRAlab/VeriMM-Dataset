module sum2bits (
    input [3:0] in,
    output reg [1:0] out
);

    always @(*) begin
        if (in[3:2] + in[1:0] >= 2) begin
            out = 2;
        end else begin
            out = in[3:2] + in[1:0];
        end
    end

endmodule