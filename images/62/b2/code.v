module shift_register_8bit(clk, rst, load, D, Q);
    input clk, rst, load;
    input [7:0] D;
    output reg [7:0] Q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            Q <= 8'b00000000;
        else if (load)
            Q <= D;
        else
            Q <= {Q[6:0], 1'b0};
    end
endmodule