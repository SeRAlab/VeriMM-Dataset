module top_module(
    input [3:0] in0,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input [1:0] sel,
    output reg [3:0] out
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

// Stage 1
always @(*) begin
    case(sel)
        2'b00: stage1_out = in0;
        2'b01: stage1_out = in1;
        2'b10: stage1_out = in2;
        2'b11: stage1_out = in3;
    endcase
end

// Stage 2
always @(*) begin
    stage2_out[0] = stage1_out[0];
    stage2_out[1] = stage1_out[1];
    stage2_out[2] = stage1_out[2];
    stage2_out[3] = stage1_out[3];
    
    // Invert stage1_out
    stage1_out[0] = ~stage1_out[0];
    stage1_out[1] = ~stage1_out[1];
    stage1_out[2] = ~stage1_out[2];
    stage1_out[3] = ~stage1_out[3];
    
    // Add inverted stage1_out to stage2_out
    out[0] = stage1_out[0] + stage2_out[0];
    out[1] = stage1_out[1] + stage2_out[1];
    out[2] = stage1_out[2] + stage2_out[2];
    out[3] = stage1_out[3] + stage2_out[3];
end

endmodule