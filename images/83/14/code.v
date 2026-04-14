module top_module(
    input wire [2:0] vec,
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0
);wire [1:0] sel;

assign sel[1] = 1'b0;
assign sel[0] = 1'b0;

assign outv = {vec[2], vec[1], vec[0]};
assign o2 = vec[2] ? 1'b1 : 1'b0;
assign o1 = vec[1] ? 1'b1 : 1'b0;
assign o0 = vec[0] ? 1'b1 : 1'b0;

wire mux2_out0, mux2_out1, mux2_out2;

// Definition of a 2-to-1 multiplexer
function [1:0] mux2 (
    input [1:0] in0,
    input [1:0] in1,
    input sel
);
begin
    mux2 = sel ? in1 : in0;
end
endfunction

assign outv[0] = mux2({1'b0}, o0, sel[0]);
assign outv[1] = mux2({1'b0}, o1, sel[0]);
assign outv[2] = mux2({1'b0}, o2, sel[0]);

endmodule