module mux2to1_64bit (
    input [63:0] a,
    input [63:0] b,
    input sel,
    output reg [63:0] y
);

    always @(*) begin
        case (sel)
            1'b0: y = a;
            1'b1: y = b;
            default: y = 64'b0000000000000000000000000000000000000000000000000000000000000000;
        endcase
    end

endmodule