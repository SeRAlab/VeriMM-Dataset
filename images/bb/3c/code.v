module top_module(
    output reg [1:0] DOA,
    output reg [1:0] DOB,
    output reg [1:0] DOC,
    output reg [1:0] DOD,
    input [4:0] ADDRA,
    input [4:0] ADDRB,
    input [4:0] ADDRC,
    input [4:0] ADDRD,
    input [1:0] DIA,
    input [1:0] DIB,
    input [1:0] DIC,
    input [1:0] DID,
    input WCLK,
    input WE
);parameter [63:0] INIT_A = 64'h0000000000000000;
parameter [63:0] INIT_B = 64'h0000000000000000;
parameter [63:0] INIT_C = 64'h0000000000000000;
parameter [63:0] INIT_D = 64'h0000000000000000;
parameter [0:0] IS_WCLK_INVERTED = 1'b0;

reg [1:0] ram [0:31];

initial begin
    ram[0][0] = INIT_A[0];
    ram[0][1] = INIT_A[1];
    ram[1][0] = INIT_B[0];
    ram[1][1] = INIT_B[1];
    ram[2][0] = INIT_C[0];
    ram[2][1] = INIT_C[1];
    ram[3][0] = INIT_D[0];
    ram[3][1] = INIT_D[1];
end

always @(*) begin
    DOA = ram[ADDRA][WE ? DIA : 2'b0];
    DOB = ram[ADDRB][WE ? DIB : 2'b0];
    DOC = ram[ADDRC][WE ? DIC : 2'b0];
    DOD = ram[ADDRD][WE ? DID : 2'b0];
end

always @(posedge WCLK) begin
    if (WE) begin
        ram[ADDRA][0] <= DIA[0];
        ram[ADDRA][1] <= DIA[1];
        ram[ADDRB][0] <= DIB[0];
        ram[ADDRB][1] <= DIB[1];
        ram[ADDRC][0] <= DIC[0];
        ram[ADDRC][1] <= DIC[1];
        ram[ADDRD][0] <= DID[0];
        ram[ADDRD][1] <= DID[1];
    end
end

endmodule