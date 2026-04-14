module top_module(
    input [4:0] I0,
    input [4:0] I1,
    input S,
    output [4:0] O
);reg [4:0] coreir_commonlib_mux2x5_inst0_out;
always @(*) begin
if (S == 0) begin
    coreir_commonlib_mux2x5_inst0_out = I0;
end else begin
    coreir_commonlib_mux2x5_inst0_out = I1;
end
end

assign O = coreir_commonlib_mux2x5_inst0_out;endmodule