module shift_register_16bit(clk, rst, load, shift_left, shift_right, D, Q);
    input clk, rst, load, shift_left, shift_right;
    input [15:0] D;
    output reg [15:0] Q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            Q <= 16'b0;
        else if (load)
            Q <= D;
        else if (shift_left)
            Q <= {Q[14:0], 1'b0};
        else if (shift_right)
            Q <= {1'b0, Q[15:1]};
    end
endmodule