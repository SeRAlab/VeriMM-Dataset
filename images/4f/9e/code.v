module top_module(
    input [3:0] in_0,
    input [3:0] in_1,
    input clk,            // Added clk input
    output reg [7:0] out
);reg [3:0] stage_1_out;
reg [3:0] stage_2_out;
reg parity;

always @(*) begin
    stage_1_out = in_0 * in_1;
end

always @(posedge clk) begin
    stage_2_out <= stage_1_out;
end

always @(posedge clk) begin
    parity <= out[7] ^ out[6] ^ out[5] ^ out[4] ^ out[3] ^ out[2] ^ out[1] ^ out[0];
    out <= {stage_2_out, parity};
end

endmodule