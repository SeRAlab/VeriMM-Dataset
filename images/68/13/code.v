module top_module(
    input [3:0] B,
    input clk,          // Added clock input signal
    output reg [3:0] E
);reg [3:0] B_reg1, B_reg2, B_reg3;
reg [3:0] E_reg1, E_reg2, E_reg3;

always @(posedge clk) begin
    B_reg1 <= B;
    E_reg1 <= B_reg1 + 4'b0011;
end

always @(posedge clk) begin
    B_reg2 <= B_reg1;
    E_reg2 <= E_reg1;
end

always @(posedge clk) begin
    B_reg3 <= B_reg2;
    E_reg3 <= E_reg2;
end

assign E = E_reg3;

endmodule