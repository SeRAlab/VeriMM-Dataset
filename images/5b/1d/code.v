module top_module(input clk, input [7:0] d, output reg [23:0] q);reg [7:0] reg1, reg2, reg3;

always @(posedge clk) begin
    reg3 <= reg2;
    reg2 <= reg1;
    reg1 <= d;
    q <= {reg3, reg2, reg1};
end

endmodule