module shift_reg_4bit (
    input clk,
    input load,
    input shift,
    input [3:0] data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (shift)
            q <= {1'b0, q[3:1]};
    end
endmodule