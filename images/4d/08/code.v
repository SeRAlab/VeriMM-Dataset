module and_4bit_module (
    input [3:0] a,
    input [3:0] b,
    output reg [3:0] result
);

    always @(*) begin
        result = a & b;
    end
endmodule