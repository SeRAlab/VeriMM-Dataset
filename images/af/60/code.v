module decoder3to8 (
    input [2:0] a,
    output reg [7:0] y
);

    always_comb begin
        y = 8'b0;
        y[a] = 1'b1;
    end

endmodule