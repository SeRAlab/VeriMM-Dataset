module top_module(
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] difference
);integer inside_sub_a = 1;

always @(*) begin
    difference = A - B;
end

endmodule