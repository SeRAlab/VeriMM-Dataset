module simple_adder (
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] C
);

always @ (A, B) begin
    C = A + B;
end

endmodule