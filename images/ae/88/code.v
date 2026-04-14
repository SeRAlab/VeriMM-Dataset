module top_module(
    input clk,          // Added clk input
    input [7:0] in,
    output reg [2:0] pos
);reg [7:0] in_reg [2:0];

always @(posedge clk) begin
    in_reg[0] <= in;
    in_reg[1] <= in_reg[0];
    in_reg[2] <= in_reg[1];
    
    if (in_reg[0] == 0) begin
        pos <= 0;
    end else if (in_reg[0][7] == 1) begin
        pos <= 7;
    end else if (in_reg[0][6] == 1) begin
        pos <= 6;
    end else if (in_reg[0][5] == 1) begin
        pos <= 5;
    end else if (in_reg[0][4] == 1) begin
        pos <= 4;
    end else if (in_reg[0][3] == 1) begin
        pos <= 3;
    end else if (in_reg[0][2] == 1) begin
        pos <= 2;
    end else if (in_reg[0][1] == 1) begin
        pos <= 1;
    end else if (in_reg[0][0] == 1) begin
        pos <= 0;
    end
end

endmodule