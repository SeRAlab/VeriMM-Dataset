module top_module(
    input clk,           // Added the clk input
    input [3:0] in,
    output reg [1:0] pos
);reg [3:0] in_reg1, in_reg2;
reg [1:0] pos_reg1, pos_reg2;

always @ (posedge clk) begin
    in_reg1 <= in;
    pos_reg1 <= pos;
    in_reg2 <= in_reg1;
    pos_reg2 <= pos_reg1;
end

always @ (posedge clk) begin
    if (in_reg2[3]) begin
        pos <= 2'b11;
    end else if (in_reg2[2]) begin
        pos <= 2'b10;
    end else if (in_reg2[1]) begin
        pos <= 2'b01;
    end else if (in_reg2[0]) begin
        pos <= 2'b00;
    end else begin
        pos <= 2'b00;
    end
end

endmodule