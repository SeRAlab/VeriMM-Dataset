module d_flip_flop (clk, reset, D, Q);
input clk, reset, D;
output reg Q;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        Q <= 1'b0;
    end else begin
        Q <= D;
    end
end

endmodule