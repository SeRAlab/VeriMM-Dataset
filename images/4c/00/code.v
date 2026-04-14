module shift_reg_4bit(
    input clk,
    input load,
    input [3:0] d,
    output reg [3:0] q);

    always @(posedge clk) begin
        if (load)
            q <= d;
        else
            q <= {q[2:0], 1'b0};
    end
endmodule