module shift_register(
    input clk,
    input rst,
    input load,
    input [3:0] d,
    input sin,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (rst)
        q <= 4'b0000;
    else if (load)
        q <= d;
    else
        q <= {sin, q[3:1]};
end

endmodule