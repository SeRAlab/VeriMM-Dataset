module top_module(
    input wire clk,        // Add the clk input
    input wire [2:0] in_vec,
    output wire [2:0] out_vec,
    output wire o2,
    output wire o1,
    output wire o0
);reg [2:0] stage1_out;
reg [2:0] stage2_out;

assign out_vec = stage2_out;
assign o2 = stage1_out[2];
assign o1 = stage1_out[1];
assign o0 = stage1_out[0];

always @(*) begin
    stage1_out[2] = in_vec[2];
    stage1_out[1] = in_vec[1];
    stage1_out[0] = in_vec[0];
end

always @(posedge clk) begin
    stage2_out <= stage1_out;
end

endmodule