module shift_register(
    input clk,
    input rst,
    input d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (rst)
            q <= 8'b00000000;
        else
            q <= {d, q[7:1]};
    end

endmodule