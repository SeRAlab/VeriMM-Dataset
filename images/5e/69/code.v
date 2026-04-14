module shift_register(CLK, RST, load, shift_left, shift_right, parallel_in, q);
input CLK, RST, load, shift_left, shift_right;
input [3:0] parallel_in;
output [3:0] q;
reg [3:0] q;

always@(posedge CLK or posedge RST) begin
    if (RST)
        q <= 0;
    else if (load)
        q <= parallel_in;
    else if (shift_left)
        q <= q << 1;
    else if (shift_right)
        q <= q >> 1;
    else
        q <= q;
end

endmodule