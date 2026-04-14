module not_module (
    input [3:0] a,
    output reg [3:0] result
);

    always @(*) begin
        result = ~a;
    end
endmodule