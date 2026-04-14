module decoder4to16 (
    input [3:0] a,
    output reg [15:0] y
);

    always_comb begin
        y = 16'b0;
        y[a] = 1'b1;
    end

endmodule