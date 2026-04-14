module multiplier (
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] result
);

    always @ (a, b) begin
        result = a * b;
    end

endmodule