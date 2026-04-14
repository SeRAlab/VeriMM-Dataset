module top_module(
    input [15:0] data_in,
    input [3:0] shift_amt,
    output [15:0] data_out
);reg [15:0] stage1_out, stage2_out, stage3_out, stage4_out;

// Stage 1: Shift left by 8 bits
always @(*) begin
    stage1_out = {data_in[7:0], data_in};
end

// Stage 2: Shift left by 4 bits
always @(*) begin
    stage2_out = {stage1_out[3:0], stage1_out};
end

// Stage 3: Shift left by 2 bits, right by 2 bits, or rotate left by 2 bits
always @(*) begin
    case(shift_amt[1:0])
        2'b00: stage3_out = {stage2_out[1:0], stage2_out[15:2]};
        2'b01: stage3_out = {stage2_out[3:0], stage2_out[15:4]};
        2'b10: stage3_out = {stage2_out[5:0], stage2_out[15:6]};
        2'b11: stage3_out = {stage2_out[7:0], stage2_out[15:8]};
    endcase
end

// Stage 4: Shift left by 1 bit, right by 1 bit, or rotate left by 1 bit
always @(*) begin
    case(shift_amt[3:2])
        2'b00: stage4_out = {stage3_out[0], stage3_out[15:1]};
        2'b01: stage4_out = {stage3_out[2:0], stage3_out[15:3]};
        2'b10: stage4_out = {stage3_out[4:0], stage3_out[15:5]};
        2'b11: stage4_out = {stage3_out[6:0], stage3_out[15:7]};
    endcase
end

assign data_out = stage4_out;

endmodule