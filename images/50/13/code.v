module shift_register (
    input clk,
    input load,
    input shift,
    input [3:0] load_value,
    output reg [3:0] q);always @(posedge clk) begin
    if (load)
        q <= load_value;
    else if (shift)
        q <= {1'b0, q[3:1]};
end
endmodule