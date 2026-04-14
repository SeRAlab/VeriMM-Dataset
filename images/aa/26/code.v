module top_module( 
    input wire [3:0] vec1,
    input wire [3:0] vec2,
    output wire [3:0] out_xor,
    output wire o4,
    output wire o3,
    output wire o2,
    output wire o1,
    output wire o0  );// Pipeline registers
    reg [3:0] stage1_out;
    reg [3:0] stage2_out;
    reg [3:0] stage3_out;
    reg [3:0] stage4_out;
    
    // Stage 1
    always @ (vec1, vec2) begin
        stage1_out <= vec1 ^ vec2;
    end
    
    // Stage 2
    always @ (stage1_out) begin
        stage2_out <= stage1_out;
    end
    
    // Stage 3
    always @ (stage2_out) begin
        stage3_out <= stage2_out;
    end
    
    // Stage 4
    always @ (stage3_out) begin
        stage4_out <= stage3_out;
    end
    
    // Output assignments
    assign out_xor = stage4_out;
    assign o4 = stage4_out[3];
    assign o3 = stage4_out[2];
    assign o2 = stage4_out[1];
    assign o1 = stage4_out[0];
    assign o0 = vec1 & vec2;
    
endmodule