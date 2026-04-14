module top_module(
    input [3:0] D,
    input [1:0] A,
    output [3:0] S
);reg [3:0] stage1_out;
reg [3:0] stage2_out;
reg [3:0] stage3_out;

always @(*) begin
    case(A)
        2'b00: stage1_out = D;
        2'b01: stage1_out = {D[2:0], 1'b0};
        2'b10: stage1_out = {D[1:0], 2'b00};
        2'b11: stage1_out = {D[0], 3'b000};
    endcase
end

always @(*) begin
    case(A)
        2'b00: stage2_out = stage1_out;
        2'b01: stage2_out = {stage1_out[1:0], 2'b00};
        2'b10: stage2_out = {stage1_out[0], 3'b000};
        2'b11: stage2_out = 4'b0000;
    endcase
end

always @(*) begin
    case(A)
        2'b00: stage3_out = stage2_out;
        2'b01: stage3_out = {stage2_out[2:0], 1'b0};
        2'b10: stage3_out = {stage2_out[1:0], 2'b00};
        2'b11: stage3_out = {stage2_out[0], 3'b000};
    endcase
end

assign S = stage3_out;

endmodule