module reg_file(
    input clk,
    input rst,
    input we,
    input [2:0] ra1,
    input [2:0] ra2,
    input [2:0] wa,
    input [31:0] wd,

    output reg [31:0] rd1,
    output reg [31:0] rd2
);

reg [31:0] regs[7:0];

always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        regs[0] <= 0;
        regs[1] <= 0;
        regs[2] <= 0;
        regs[3] <= 0;
        regs[4] <= 0;
        regs[5] <= 0;
        regs[6] <= 0;
        regs[7] <= 0;
    end
    else if(we)
        regs[wa] <= wd;
end

always@(*)
begin
    rd1 = regs[ra1];
    rd2 = regs[ra2];
end

endmodule