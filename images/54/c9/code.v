module top_module(clk, in, out_1, out_2);input              clk;
    input      [191:0] in;
    output reg [191:0] out_1;
    output     [127:0] out_2;
    wire       [31:0]  k0, k1, k2, k3, k4, k5,
                       v2, v3, v4, v5;
    reg        [31:0]  k0a, k1a, k2a, k3a, k4a, k5a;

    assign {k0, k1, k2, k3, k4, k5} = in;
    
    assign v2 = k1 ^ k2;
    assign v3 = v2 ^ k3;
    assign v4 = v3 ^ k4;
    assign v5 = v4 ^ k5;

    always @ (posedge clk)
        {k0a, k1a, k2a, k3a, k4a, k5a} <= {k0, k1, v2, v3, v4, v5};

    always @ (posedge clk)
        out_1 <= {k0a, k1a, k2a, k3a, k4a, k5a};

    assign out_2 = {k2a, k3a, k4a, k5a};
endmodule