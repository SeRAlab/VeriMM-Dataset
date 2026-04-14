module and_logic(
    input [3:0] A,
    input [3:0] B,
    input reset,
    output reg [3:0] C
);

always @(A, B, reset) begin
    if(reset) begin
        C <= 4'b0000;
    end else begin
        C <= A & B;
    end
end

endmodule