module top_module(
    input clk,
    input [15:0] in,
    output [3:0] out
);reg [15:0] in_reg [0:3];
reg [3:0] out_reg;
reg [15:0] in_delayed;
reg [15:0] in_delayed_reg;

always @(posedge clk) begin
    in_reg[0] <= in;
    in_reg[1] <= in_reg[0];
    in_reg[2] <= in_reg[1];
    in_reg[3] <= in_reg[2];
    
    in_delayed <= in_reg[3];
    in_delayed_reg <= in_reg[2];
    
    if (in_delayed == 16'h0000 && in_delayed_reg == 16'hFFFF) begin
        out_reg <= out_reg + 1;
    end else begin
        out_reg <= out_reg;
    end
end

assign out = out_reg;

endmodule