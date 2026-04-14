module top_module(
    input [3:0] data,
    input rotate,
    input clk,             // Added clk input
    output reg [3:0] shifted_data
);reg [3:0] stage1_data;
reg [3:0] stage2_data;

always @ (posedge clk) begin
    stage1_data <= data;
end

always @ (posedge clk) begin
    stage2_data <= stage1_data;
end

always @ (posedge clk) begin
    if (rotate == 1'b0) begin
        shifted_data <= {stage2_data[2:0], stage2_data[3]};
    end else begin
        shifted_data <= {stage2_data[2:0], stage2_data[3]} ^ {1'b0, stage2_data[0]};
    end
end

endmodule