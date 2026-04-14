module top_module(
    input enable,
    input [1:0] in,
    output reg [3:0] out
);reg [1:0] stage1_out;
reg [3:0] stage2_out;

always @ (posedge enable) begin
    stage1_out <= in;
end

always @ (posedge enable) begin
    case (stage1_out)
        2'b00: stage2_out <= 4'b0001;
        2'b01: stage2_out <= 4'b0010;
        2'b10: stage2_out <= 4'b0100;
        2'b11: stage2_out <= 4'b1000;
        default: stage2_out <= 4'b0000;
    endcase
end

assign out = stage2_out;

endmodule