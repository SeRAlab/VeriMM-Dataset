module shift_register
(
    input clk,
    input pload,
    input [7:0] pdata,
    output reg [7:0] q
);always @(posedge clk)
    if (pload) begin
        q <= pdata;
    end else begin
        q <= {q[6:0], 1'b0};
    end
endmodule