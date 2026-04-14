module shift_register_4bit(clk, rst, load, D, Q);
    input clk, rst, load;
    input [3:0] D;
    output [3:0] Q;
    reg [3:0] Q;

    always @(posedge clk) begin
        if (rst)
            Q <= 4'b0000;
        else if (load)
            Q <= D;
        else
            Q <= {Q[2:0], Q[3]};
    end

endmodule