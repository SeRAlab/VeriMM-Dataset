module mux3to1 (
    input [2:0] a,
    input [1:0] sel,
    output reg y
);

    always_comb begin
        case (sel)
            2'b00: y = a[0];
            2'b01: y = a[1];
            2'b10: y = a[2];
            default: y = 1'b0;
        endcase
    end

endmodule