module top_module(
    input [3:0] data_in,
    input shift_en,
    input load_en,
    output reg [3:0] data_out
);reg [3:0] stage1, stage2, stage3, stage4;

always @ (posedge shift_en) begin
    stage4 <= stage3;
    stage3 <= stage2;
    stage2 <= stage1;
    stage1 <= data_in;
end

always @ (posedge load_en) begin
    stage4 <= data_in;
    stage3 <= data_in;
    stage2 <= data_in;
    stage1 <= data_in;
end

assign data_out = stage4;

endmodule