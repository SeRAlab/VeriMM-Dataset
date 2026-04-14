module multiply_module(
    input [7:0] a,
    input [7:0] b,
    output [15:0] result
);

reg [15:0] temp_result;

always @(*) begin
    temp_result = a * b;
end

assign result = temp_result;

endmodule