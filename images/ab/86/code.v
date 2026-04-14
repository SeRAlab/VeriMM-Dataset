module top_module(
    input [3:0] I,
    input clk,            // Added `clk` input
    output reg [1:0] Y
);reg [1:0] stage1_out;
reg [1:0] stage2_out;

always @ (posedge clk) begin
    stage1_out <= {I[1], I[0]};
    stage2_out <= {I[3], I[2]};
end

always @ (posedge clk) begin
    if (stage1_out[1] == 1'b1) begin
        Y <= stage1_out;
    end else if (stage2_out[1] == 1'b1) begin
        Y <= stage2_out;
    end else begin
        Y <= 2'b00;
    end
end

endmodule