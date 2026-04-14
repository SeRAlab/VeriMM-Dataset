module top_module(clk, en, resetn, loadseed_i, seed_i, number_o);input clk;
input resetn;
input en;
input loadseed_i;
input [31:0] seed_i;
output [31:0] number_o;

reg [31:0] sr1, sr2, sr3;
reg [31:0] fb1, fb2, fb3;
reg [31:0] r_s1, r_s2, r_s3;

assign number_o = sr1 ^ sr2 ^ sr3;

always @(loadseed_i or seed_i or r_s1 or r_s2 or r_s3) begin
    if (loadseed_i) begin
        sr1 = 32'b0;
        sr2 = 32'b0; // Corrected to 32 bits
        sr3 = 32'b0; // Corrected to 32 bits
        sr1[31:0] = seed_i;
        sr2[31:1] = {seed_i[29:0], 1'b0}; // Corrected to use 31:1
        sr3[31:3] = {seed_i[27:0], 2'b0}; // Corrected to use 31:3
    end else begin
        fb1 = sr1[0] ^ sr1[1] ^ sr1[3] ^ sr1[4] ^ sr1[7] ^ sr1[8] ^ sr1[11] ^
              sr1[12] ^ sr1[15] ^ sr1[19] ^ sr1[22] ^ sr1[23] ^ sr1[24] ^
              sr1[26] ^ sr1[27] ^ sr1[28] ^ sr1[30] ^ sr1[31];
        
        fb2 = sr2[0] ^ sr2[1] ^ sr2[2] ^ sr2[3] ^ sr2[4] ^ sr2[7] ^ sr2[8] ^
              sr2[10] ^ sr2[11] ^ sr2[13] ^ sr2[14] ^ sr2[17] ^ sr2[18] ^
              sr2[19] ^ sr2[20] ^ sr2[21] ^ sr2[22] ^ sr2[24] ^ sr2[25] ^
              sr2[26] ^ sr2[27] ^ sr2[28] ^ sr2[29];
              
        fb3 = sr3[0] ^ sr3[1] ^ sr3[3] ^ sr3[4] ^ sr3[5] ^ sr3[6] ^ sr3[8] ^
              sr3[9] ^ sr3[10] ^ sr3[12] ^ sr3[13] ^ sr3[16] ^ sr3[17] ^
              sr3[20] ^ sr3[21] ^ sr3[24] ^ sr3[25] ^ sr3[26] ^ sr3[27];
        
        sr1 = {fb1, sr1[31:1]}; // Corrected the part select order
        sr2 = {fb2, sr2[31:2]}; // Corrected the part select order
        sr3 = {fb3, sr3[31:3]}; // Corrected the part select order
    end
end

always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        r_s1 <= 32'b0;
        r_s2 <= 32'b0; // Corrected to 32 bits
        r_s3 <= 32'b0; // Corrected to 32 bits
    end else if (en) begin
        r_s1 <= sr1;
        r_s2 <= sr2;
        r_s3 <= sr3;
    end
end

endmodule