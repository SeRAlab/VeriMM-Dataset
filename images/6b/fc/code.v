module subtractor_32bit(
    input wire [31:0] A,
    input wire [31:0] B,
    output reg [31:0] result
    );

always @(*) begin
    result = A - B;
end

endmodule