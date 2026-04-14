module mux_4to1(sel, d0, d1, d2, d3, y);

    input [1:0] sel;
    input d0;
    input d1;
    input d2;
    input d3;
    output y;
    reg y;

    always @(sel or d0 or d1 or d2 or d3)
    begin
        case (sel)
            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            2'b11: y = d3;
            default: y = 1'b0;
        endcase
    end

endmodule