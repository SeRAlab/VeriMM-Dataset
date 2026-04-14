module d_flipflop (
    input wire clk,
    input wire clr,
    input wire pre,
    input wire D,
    output reg Q
    );

always @(posedge clk or posedge clr or posedge pre) begin
    if (clr)
        Q <= 1'b0;
    else if (pre)
        Q <= 1'b1;
    else
        Q <= D;
end

endmodule