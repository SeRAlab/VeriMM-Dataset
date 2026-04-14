module top_module(
    input clk,
    input [7:0] in,
    output reg [2:0] pos
);reg [7:0] in_reg1, in_reg2, in_reg3, in_reg4;
reg [2:0] pos_reg1, pos_reg2, pos_reg3;

always @(posedge clk) begin
    in_reg1 <= in;
    in_reg2 <= in_reg1;
    in_reg3 <= in_reg2;
    in_reg4 <= in_reg3;
    
    pos_reg1 <= pos;
    pos_reg2 <= pos_reg1;
    pos_reg3 <= pos_reg2;
    
    if (in_reg1[0]) begin
        pos <= 0;
    end else if (in_reg2[0]) begin
        pos <= 1;
    end else if (in_reg3[0]) begin
        pos <= 2;
    end else if (in_reg4[0]) begin
        pos <= 3;
    end else if (in_reg1[1]) begin
        pos <= 4;
    end else if (in_reg2[1]) begin
        pos <= 5;
    end else if (in_reg3[1]) begin
        pos <= 6;
    end else if (in_reg4[1]) begin
        pos <= 7;
    end else begin
        pos <= 0;
    end
end

endmodule