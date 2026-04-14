module shift_register (
    input clk,
    input resetn,
    input [7:0] data_in,
    output reg [7:0] q);always @(posedge clk) begin
    if (~resetn)
        q <= 8'b00000000;
    else
        q <= {q[6:0], data_in[0]};
end
endmodule