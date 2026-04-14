module top_module(
    input [3:0] A, B, C, D,
    input clk,  // Added input definition for clk
    output [3:0] Y,
    output EN
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    if (A != 4'b0000) begin
        stage1_out = 4'b1000;
    end
    else if (B != 4'b0000) begin
        stage1_out = 4'b0100;
    end
    else if (C != 4'b0000) begin
        stage1_out = 4'b0010;
    end
    else if (D != 4'b0000) begin
        stage1_out = 4'b0001;
    end
    else begin
        stage1_out = 4'b0000;
    end
end

always @(posedge clk) begin
    stage2_out <= stage1_out;
end

assign Y = (stage2_out[3]) ? A :
           (stage2_out[2]) ? B :
           (stage2_out[1]) ? C :
           (stage2_out[0]) ? D : 4'b0000;

assign EN = (stage2_out != 4'b0000);

endmodule