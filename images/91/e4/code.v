module top_module(
    input in0,
    input in1,
    input in2,
    input [1:0] sel,
    input clr,
    input set,
    output reg out
);always @(*) begin
    case(sel)
        2'b00: out = in0;
        2'b01: out = in1;
        2'b10: out = in2;
        2'b11: out = 1'b0;
    endcase
end

always @(posedge set) begin
    out <= 1'b1;
end

always @(posedge clr) begin
    out <= 1'b0;
end

endmodule