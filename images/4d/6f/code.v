module top_module(
    input [1:4] so1x,
    input [1:4] so2x,
    input [1:4] so3x,
    input [1:4] so4x,
    input [1:4] so5x,
    input [1:4] so6x,
    input [1:4] so7x,
    input [1:4] so8x,
    output [1:32] ppo
);wire [1:32] XX;
    
    assign XX[1:4] = so1x;
    assign XX[5:8] = so2x;
    assign XX[9:12] = so3x;
    assign XX[13:16] = so4x;
    assign XX[17:20] = so5x;
    assign XX[21:24] = so6x;
    assign XX[25:28] = so7x;
    assign XX[29:32] = so8x;
    
    assign ppo[1] = XX[16];
    assign ppo[2] = XX[7];
    assign ppo[3] = XX[20];
    assign ppo[4] = XX[21];
    assign ppo[5] = XX[29];
    assign ppo[6] = XX[12];
    assign ppo[7] = XX[28];
    assign ppo[8] = XX[17];
    assign ppo[9] = XX[1];
    assign ppo[10] = XX[15];
    assign ppo[11] = XX[23];
    assign ppo[12] = XX[26];
    assign ppo[13] = XX[5];
    assign ppo[14] = XX[18];
    assign ppo[15] = XX[31];
    assign ppo[16] = XX[10];
    assign ppo[17] = XX[2];
    assign ppo[18] = XX[8];
    assign ppo[19] = XX[24];
    assign ppo[20] = XX[14];
    assign ppo[21] = XX[32];
    assign ppo[22] = XX[27];
    assign ppo[23] = XX[3];
    assign ppo[24] = XX[9];
    assign ppo[25] = XX[19];
    assign ppo[26] = XX[13];
    assign ppo[27] = XX[30];
    assign ppo[28] = XX[6];
    assign ppo[29] = XX[22];
    assign ppo[30] = XX[11];
    assign ppo[31] = XX[4];
    assign ppo[32] = XX[25];

endmodule