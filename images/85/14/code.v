module johnson_counter (
    input clk,
    output reg [4:0] q
);
always @(posedge clk) begin
    q <= {~q[0], q[4:1]};
end
endmodule