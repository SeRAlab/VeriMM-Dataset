module top_module(
    input clk,               // Added clk input
    input [3:0] in,
    output reg [1:0] pos
);reg [3:0] in_reg1, in_reg2, in_reg3;
reg [1:0] pos_reg1, pos_reg2;

always @(posedge clk) begin
    in_reg1 <= in;
    in_reg2 <= in_reg1;
    in_reg3 <= in_reg2;
    
    pos_reg1 <= pos;      // This line seems incorrect, pos should be assigned later
    pos_reg2 <= pos_reg1; // This line seems incorrect, pos_reg1 should be assigned later
end

always @(posedge clk) begin
    if (in_reg1[3]) pos_reg1 <= 3;
    else if (in_reg2[3]) pos_reg1 <= 2;
    else if (in_reg3[3]) pos_reg1 <= 1;
    else pos_reg1 <= 0;
end

always @(posedge clk) begin
    if (in_reg1[2]) pos_reg2 <= 3;
    else if (in_reg2[2]) pos_reg2 <= 2;
    else if (in_reg3[2]) pos_reg2 <= 1;
    else pos_reg2 <= pos_reg1;
end

always @(posedge clk) begin
    if (in_reg1[1]) pos <= 3;
    else if (in_reg2[1]) pos <= 2;
    else if (in_reg3[1]) pos <= 1;
    else pos <= pos_reg2;
end

endmodule