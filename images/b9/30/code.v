module shift_reg_4bit(clk, rst, load, data_in, q);

    input clk;
    input rst;
    input load;
    input [3:0] data_in;
    output [3:0] q;
    reg [3:0] q;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
            q <= 4'b0000;
        else if (load)
            q <= data_in;
        else
            q <= {1'b0, q[3:1]};
    end

endmodule