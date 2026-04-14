module shift_register_4bit
(
    input clk,
    input load,
    input [3:0] pdata,
    output reg [3:0] q
);

always @(posedge clk)
begin
    if (load)
        q <= pdata;
    else
        q <= {q[2:0], 1'b0};
end

endmodule