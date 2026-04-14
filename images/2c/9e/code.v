module pipeline_adder (
    input clk,
    input reset,
    input start,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] sum,
    output reg done
);

    reg [7:0] stage_reg [0:6]; // pipeline registers for 7 stages
    reg [2:0] current_stage;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_stage <= 0;
            sum <= 0;
            done <= 0;
        end else if (start && current_stage < 7) begin
            case (current_stage)
                0: stage_reg[0] <= a;                // Capture input a
                1: stage_reg[1] <= b;                // Capture input b
                2: stage_reg[2] <= stage_reg[0];     // Forward input a
                3: stage_reg[3] <= stage_reg[1];     // Forward input b
                4: stage_reg[4] <= stage_reg[2] + stage_reg[3]; // Perform addition
                5: stage_reg[5] <= stage_reg[4];     // Forward result
                6: begin
                    sum <= stage_reg[5];             // Output the result
                    done <= 1;                       // Indicate that operation is complete
                end
            endcase
            current_stage <= current_stage + 1;
        end
    end
endmodule