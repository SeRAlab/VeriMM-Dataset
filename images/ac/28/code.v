module mux8to1 (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    input [3:0] f,
    input [3:0] g,
    input [3:0] h,
    input [2:0] sel,
    output reg [3:0] y
);

    always @(*) begin
        case (sel)
            3'b000: y = a;
            3'b001: y = b;
            3'b010: y = c;
            3'b011: y = d;
            3'b100: y = e;
            3'b101: y = f;
            3'b110: y = g;
            3'b111: y = h;
            default: y = 4'b0000;
        endcase
    end

endmodule