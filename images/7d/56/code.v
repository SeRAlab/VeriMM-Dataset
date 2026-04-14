module decoder5to32 (
    input [4:0] a,
    output reg [31:0] y
);

    always_comb begin
        y = 32'b0;
        y[a] = 1'b1;
    end

endmodule