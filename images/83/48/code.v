module mux_4to1(a, b, c, d, sel, out);

    input a, b, c, d;
    input [1:0] sel;
    output out;
    reg out;

    always @(*)
        begin
            case (sel)
                2'b00: out = a;
                2'b01: out = b;
                2'b10: out = c;
                2'b11: out = d;
                default: out = 1'b0;
            endcase
        end

endmodule