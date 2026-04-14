module binary_adder(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] S,
    output reg C
);

    always @(*) begin
        S = A + B;
        C = (S > 4'b1111) ? 1 : 0;
    end
    
endmodule