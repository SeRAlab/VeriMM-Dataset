module top_module( 
    input wire [7:0] in_hi,
    input wire [7:0] in_lo,
    output reg [15:0] out );// Changed output to reg

    // Pipeline registers
    reg [7:0] stage1_out_hi;
    reg [7:0] stage1_out_lo;

    // Stage 1: Combine the two input bytes
    always @(*) begin
        stage1_out_hi = in_hi;
        stage1_out_lo = in_lo;
    end

    // Stage 2: Combine the two bytes into a half-word
    always @(*) begin
        out = {stage1_out_hi, stage1_out_lo};
    end

endmodule