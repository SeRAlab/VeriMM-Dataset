module top_module(OUT, A, B, MODE);input [3:0] A, B;
input [1:0] MODE;
output reg [7:0] OUT;





always @(*) begin
    case(MODE)
        0: OUT = A+B;
        1: OUT = A&B;
        2: OUT = (A>B)?1:0;
        3: OUT = A>>B;
    endcase
end

endmodule