module mux_4to1
(
    input in0,
    input in1,
    input in2,
    input in3,
    input [1:0] sel,
    output reg out
);

always @(*) begin
    case (sel)
        2'd0: out = in0;
        2'd1: out = in1;
        2'd2: out = in2;
        2'd3: out = in3;
        default: out = 1'b0;
    endcase
end

endmodule