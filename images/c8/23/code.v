module adder(input [7:0] a, input [7:0] b, input [7:0] c, input [7:0] d, output reg [8:0] sum);

always @(*) begin
    sum = {1'b0, a} + {1'b0, b} + {1'b0, c} + {1'b0, d};
end

endmodule