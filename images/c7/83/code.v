module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input enable,
    output reg [8:0] sum
);

always @(*) begin
    if (enable) begin
        sum = {1'b0, a} + {1'b0, b};
    end else begin
        sum = 9'b0;
    end
end

endmodule