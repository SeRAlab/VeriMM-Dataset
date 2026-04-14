module top_module(
    input [7:0] in,
    input sel,
    output reg [2:0] pos,
    output reg [7:0] out_always );reg [7:0] in_reg;
    reg [2:0] pos_reg;
    
    always @(*) begin
        in_reg = in;
        pos_reg = 0;
        if (in_reg[7] == 1) pos_reg = 7;
        else if (in_reg[6] == 1) pos_reg = 6;
        else if (in_reg[5] == 1) pos_reg = 5;
        else if (in_reg[4] == 1) pos_reg = 4;
        else if (in_reg[3] == 1) pos_reg = 3;
        else if (in_reg[2] == 1) pos_reg = 2;
        else if (in_reg[1] == 1) pos_reg = 1;
        else if (in_reg[0] == 1) pos_reg = 0;
        pos = pos_reg;
    end
    
    always @(posedge sel) begin
        if (sel == 1) out_always = pos_reg;
        else out_always = in_reg;
    end
    
endmodule