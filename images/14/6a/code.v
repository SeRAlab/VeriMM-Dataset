module wallace_tree_adder (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    output reg [6:0] sum
);
    always @(*) begin
        sum = a + b + c;
    end
endmodule