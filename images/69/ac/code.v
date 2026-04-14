module mux_8to1(
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    input wire e,
    input wire f,
    input wire g,
    input wire h,
    input wire [2:0] sel,
    output reg y
);

    always @(*) begin
        case(sel)
            3'b000: y = a;
            3'b001: y = b;
            3'b010: y = c;
            3'b011: y = d;
            3'b100: y = e;
            3'b101: y = f;
            3'b110: y = g;
            3'b111: y = h;
            default: y = 1'b0;
        endcase
    end
endmodule