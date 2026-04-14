module top_module(clk, regA, regB, regTEST, regW, Wdat, RegWrite, Adat, Bdat, TESTdat);input clk, RegWrite;
    input [4:0] regTEST, regA, regB, regW;
    input [31:0] Wdat;
    output wire [31:0] Adat, Bdat, TESTdat;
    reg [31:0] regfile [0:31];
    assign Adat = regfile[regA];
    assign Bdat = regfile[regB];
    assign TESTdat = regfile[regTEST];
    always @(posedge clk) begin
        if (RegWrite) begin
            if (regW != 0) begin
                regfile[regW] <= Wdat;
            end
        end
    end
endmodule