module mux5to1 (
    input [1:0] a,
    input [1:0] b,
    input [1:0] c,
    input [1:0] d,
    input [1:0] e,
    input [2:0] sel,
    output reg [1:0] y
);

    always @(*) begin
        case (sel)
            3'b000: y = a;
            3'b001: y = b;
            3'b010: y = c;
            3'b011: y = d;
            3'b100: y = e;
            default: y = 2'b00;
        endcase
    end

endmodule