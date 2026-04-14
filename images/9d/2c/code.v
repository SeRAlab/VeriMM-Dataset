module top_module(
    input [3:0] binary_in,
    input clk, // Added clk as an input
    output reg [3:0] bcd_out,
    output reg greater_than_nine
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    if(binary_in >= 5) begin
        stage1_out = binary_in - 5;
        greater_than_nine = 1;
    end else begin
        stage1_out = binary_in;
        greater_than_nine = 0;
    end
end

always @(posedge clk) begin
    stage2_out <= stage1_out >= 5 ? stage1_out - 5 : stage1_out;
    bcd_out <= stage2_out; // Corrected to assign stage2_out to bcd_out
end

endmodule