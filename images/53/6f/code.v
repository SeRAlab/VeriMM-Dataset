module d_latch(
    input [2:0] d,
    input en,
    output reg [2:0] q
);

    always @(*) begin
        if (en)
            q <= d;
    end

endmodule