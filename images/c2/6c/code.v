module mux4to1 (
    in0,
    in1,
    in2,
    in3,
    out,
    sel0,
    sel1
);

    input [3:0] in0, in1, in2, in3;
    output [3:0] out;
    input sel0, sel1;

    wire [3:0] sel;

    assign sel = {sel1, sel0};

    always @(*) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
        endcase
    end

endmodule