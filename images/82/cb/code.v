module top_module(
    input enable,
    input [1:0] select,
    input invert,
    output reg [7:0] out
);reg [7:0] stage1_out;
reg [7:0] stage2_out;

always @(posedge enable) begin
    stage1_out <= {~(select[1] & select[0]), ~(select[1] & ~select[0]), ~(~select[1] & select[0]), ~(~select[1] & ~select[0]), ~(select[1] & select[0]), ~(select[1] & ~select[0]), ~(~select[1] & select[0]), ~(~select[1] & ~select[0])};
end

always @(posedge enable) begin
    stage2_out <= invert ? ~stage1_out : stage1_out;
end

assign out = stage2_out;

endmodule