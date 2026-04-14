module top_module(
    input wire clk,           // Added clk input
    input wire [2:0] vec,
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0
);reg [2:0] stage1_out;
reg [2:0] stage2_out;
reg [2:0] stage3_out;

assign o2 = vec[2];
assign o1 = vec[1];
assign o0 = vec[0];

always @ (posedge clk) begin
    stage1_out <= vec;
end

always @ (posedge clk) begin
    stage2_out <= stage1_out;
end

always @ (posedge clk) begin
    stage3_out <= stage2_out;
end

assign outv = stage3_out;

endmodule