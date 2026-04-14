module mux_2to1_4bit
(
    input sel,
    input [3:0] in0,
    input [3:0] in1,
    output reg [3:0] out
);

always @(*) begin
    case (sel)
        1'b0: out = in0;
        1'b1: out = in1;
        default: out = 4'd0;
    endcase
end

endmodule