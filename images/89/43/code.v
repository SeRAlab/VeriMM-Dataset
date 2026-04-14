module shift_register_8bit(clk, D, Q);
input clk, D;
output reg [7:0] Q;

always @(posedge clk) begin
    Q <= {D, Q[7:1]};
end

endmodule