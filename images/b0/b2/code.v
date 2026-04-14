module top_module(
    input [3:0] in0,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input [1:0] sel,
    input       reset,
    output reg  [3:0] out_assign,
    output reg  [3:0] out_alwaysblock
);wire [3:0] mux1_out, mux2_out;

assign mux1_out = (sel[0] == 1'b0) ? in0 : in1;
assign mux2_out = (sel[0] == 1'b0) ? in2 : in3;

always @(*) begin
    case (sel[1])
        1'b0: out_alwaysblock = mux1_out;
        1'b1: out_alwaysblock = mux2_out;
        default: out_alwaysblock = 4'b0;
    endcase
end

always @(posedge reset) begin
    if (reset) begin
        out_assign <= 4'b0;
    end else begin
        case (sel)
            2'b00: out_assign <= in0;
            2'b01: out_assign <= in1;
            2'b10: out_assign <= in2;
            2'b11: out_assign <= in3;
            default: out_assign <= 4'b0;
        endcase
    end
end

endmodule