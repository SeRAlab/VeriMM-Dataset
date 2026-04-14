module mux_2to1(
    input wire a,
    input wire b,
    input wire sel,
    output reg y
);

    always @(*) begin
        case(sel)
            1'b0: y = a;
            1'b1: y = b;
            default: y = 1'b0;
        endcase
    end
endmodule