module top_module(
    input clk,               // Added clk input declaration
    input [7:0] in,
    output reg [2:0] out
);reg [7:0] in_reg;
reg [2:0] out_reg;

always @(posedge clk) begin
    in_reg <= in;
end

always @(posedge clk) begin
    if (in_reg[0]) out_reg <= 3'b001;
    else if (in_reg[1]) out_reg <= 3'b010;
    else if (in_reg[2]) out_reg <= 3'b011;
    else if (in_reg[3]) out_reg <= 3'b100;
    else if (in_reg[4]) out_reg <= 3'b101;
    else if (in_reg[5]) out_reg <= 3'b110;
    else if (in_reg[6]) out_reg <= 3'b111;
    else if (in_reg[7]) out_reg <= 3'b000;
    else out_reg <= 3'b000; // default output when no input is valid
end

assign out = out_reg;

endmodule