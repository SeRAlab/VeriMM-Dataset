module pipeline_adder (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    input valid_in,
    output reg [7:0] result,
    output reg valid_out
);
    
    reg [7:0] stage1_a, stage1_b;
    reg [7:0] stage2_a, stage2_b;
    reg [7:0] stage3_result;
    reg [2:0] state;
    reg valid_stage1, valid_stage2, valid_stage3;
    
    parameter IDLE = 3'b000, STAGE1 = 3'b001, STAGE2 = 3'b010, STAGE3 = 3'b011, STAGE4 = 3'b100, STAGE5 = 3'b101, STAGE6 = 3'b110;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            result <= 8'b0;
            valid_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (valid_in) begin
                        stage1_a <= a;
                        stage1_b <= b;
                        valid_stage1 <= 1;
                        state <= STAGE1;
                    end
                end
                STAGE1: begin
                    if (valid_stage1) begin
                        stage2_a <= stage1_a;
                        stage2_b <= stage1_b;
                        valid_stage2 <= 1;
                        state <= STAGE2;
                    end
                end
                STAGE2: begin
                    if (valid_stage2) begin
                        stage3_result <= stage2_a + stage2_b;
                        valid_stage3 <= 1;
                        state <= STAGE3;
                    end
                end
                STAGE3: begin
                    result <= stage3_result; // Write Back stage
                    valid_out <= 1;
                    state <= IDLE; // Reset to IDLE after completing the operation
                end
            endcase
        end
    end
endmodule