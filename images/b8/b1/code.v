module top_module(
    input clk,
    input [7:0] in1,
    input [7:0] in2,
    output reg [2:0] pos 
);reg [7:0] in_reg1, in_reg2;
    reg [3:0] stage1_out, stage2_out, stage3_out;

    always @(posedge clk) begin
        in_reg1 <= in1;
        in_reg2 <= in2;
    end

    // Stage 1
    always @* begin
        if (in_reg1[7]) stage1_out = 7;
        else if (in_reg1[6]) stage1_out = 6;
        else if (in_reg1[5]) stage1_out = 5;
        else if (in_reg1[4]) stage1_out = 4;
        else if (in_reg1[3]) stage1_out = 3;
        else if (in_reg1[2]) stage1_out = 2;
        else if (in_reg1[1]) stage1_out = 1;
        else if (in_reg1[0]) stage1_out = 0;
        else stage1_out = 4'b1111; // No active signals
    end

    // Stage 2
    always @* begin
        if (in_reg2[7]) stage2_out = 7;
        else if (in_reg2[6]) stage2_out = 6;
        else if (in_reg2[5]) stage2_out = 5;
        else if (in_reg2[4]) stage2_out = 4;
        else if (in_reg2[3]) stage2_out = 3;
        else if (in_reg2[2]) stage2_out = 2;
        else if (in_reg2[1]) stage2_out = 1;
        else if (in_reg2[0]) stage2_out = 0;
        else stage2_out = 4'b1111; // No active signals
    end

    // Stage 3
    always @* begin
        if (stage1_out < stage2_out) stage3_out = stage1_out;
        else stage3_out = stage2_out;
    end

    always @(posedge clk) begin
        pos <= stage3_out[2:0]; // Ensure only 3 bits are assigned to pos
    end

endmodule