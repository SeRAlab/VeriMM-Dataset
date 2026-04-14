module shift_reg(
    input clk,
    input rst,
    input [7:0] d,
    input load,
    output reg [7:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 8'b0;
        else if (load)
            q <= d;
        else
            q <= {q[6:0], 1'b0};  // Shift left
    end

endmodule