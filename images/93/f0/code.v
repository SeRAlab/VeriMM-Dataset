module shift_register_6bit(
    input clk,
    input clr_n,
    input en,
    input [5:0] d,
    output reg [5:0] q
);

    always @(posedge clk or negedge clr_n) begin
        if (!clr_n)
            q <= 6'b000000;
        else if (en)
            q <= {q[4:0], d[0]};
    end

endmodule