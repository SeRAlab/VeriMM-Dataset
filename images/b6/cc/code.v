module top_module(
    input clk,            // Added clk input
    input [3:0] in,
    output reg [1:0] pos
);reg [1:0] stage1_out, stage2_out;

always @ (posedge clk) begin
    stage1_out <= {in[1], in[0]};
    stage2_out <= {in[3], in[2]};
    pos <= 2'b00;
    if (stage2_out[1]) pos <= 2'b11;
    else if (stage2_out[0]) pos <= 2'b10;
    else if (stage1_out[1]) pos <= 2'b01;
    else if (stage1_out[0]) pos <= 2'b00;
end

endmodule