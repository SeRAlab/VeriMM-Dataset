module top_module(
    input signed [3:0] a,
    input clk,
    input reset,
    output reg signed [3:0] sqrt,
    output error
);reg signed [3:0] stage1_out;
reg signed [3:0] stage2_out;
reg signed [3:0] stage3_out;
reg signed [3:0] stage4_out;

reg [1:0] stage;

assign error = (a < 0);

always @(*) begin
    case(stage)
        0: stage1_out = a;
        1: stage2_out = stage1_out[3:2] + 2'b10;
        2: stage3_out = {stage2_out[2], stage2_out[1], stage2_out[0], 1'b0};
        3: stage4_out = stage3_out[3:2] + 2'b10;
        default: stage4_out = 4'b0000; // Assign a default value
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        stage <= 0;
        sqrt <= 0; // Reset sqrt as well
    end else begin
        case(stage)
            0: begin
                stage1_out = a;
                stage <= 1;
            end
            1: begin
                stage2_out = stage1_out[3:2] + 2'b10;
                stage <= 2;
            end
            2: begin
                stage3_out = {stage2_out[2], stage2_out[1], stage2_out[0], 1'b0};
                stage <= 3;
            end
            3: begin
                stage4_out = stage3_out[3:2] + 2'b10;
                stage <= 4;
            end
            4: begin
                sqrt <= stage4_out; // Assign to sqrt here
                stage <= 0; // Reset stage after completion
            end
        endcase
    end
end

endmodule