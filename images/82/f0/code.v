module shift_register(clk, din, q);

    input clk;
    input din;
    output [3:0] q;
    reg [3:0] q;
    initial q = 0;

    always @(posedge clk)
        begin
            q <= {din, q[3:1]};
        end

endmodule