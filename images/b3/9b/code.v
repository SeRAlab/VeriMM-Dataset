module mux3to1 (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    input [1:0] sel,
    output reg [15:0] y
);

    always @(*) begin
        case (sel)
            2'b00: y = a;
            2'b01: y = b;
            2'b10: y = c;
            default: y = 16'b0000000000000000;
        endcase
    end

endmodule