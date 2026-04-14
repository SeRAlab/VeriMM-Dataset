module top_module(regA, regB, Wdat, regW, RegWrite, DualWrite, clk, resetn, Adat, Bdat, regTEST, TESTdat);input clk, RegWrite, resetn, DualWrite;        // write enable
    input [4:0] regA, regB, regW, regTEST;        // source/dest register address
    input [31:0] Wdat;                             // data writing to dest
    output reg [31:0] Adat, Bdat, TESTdat;        // data read from source
    reg [31:0] regfile [0:31];
    reg [5:0] i;

    always @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            for (i = 0; i < 32; i = i + 1) begin
                regfile[i] <= 0;
            end
        end else begin
            if (DualWrite) begin
                regfile[regW] <= Wdat;
            end else begin
                if (RegWrite) begin
                    regfile[regW] <= (regW == 0) ? 32'b0 : Wdat;
                end
            end
        end
    end

    always @* begin
        Adat = regfile[regA];
        Bdat = regfile[regB];
        TESTdat = regfile[regTEST];
    end
endmodule