module shift_register (
    input clk,
    input rst,
    input d,
    output reg [2:0] q
);
    always @(posedge clk) begin
        if (rst)
            q <= 3'b000;
        else
            q <= {q[1:0], d};
    end
endmodule