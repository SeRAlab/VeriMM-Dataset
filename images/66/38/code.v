module ShiftRegister (
    input clk,
    input rst,
    input load,
    input shift,
    input [3:0] d,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (rst)
            q <= 4'b0000;
        else if (load)
            q <= d;
        else if (shift)
            q <= {1'b0, q[3:1]};
    end
endmodule