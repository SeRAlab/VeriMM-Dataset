module shift_register(clk, rst, data, q);

    input  clk;
    input  rst;
    input  data;
    output reg [7:0] q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 8'b00000000;
        else
            q <= {q[6:0], data};
    end
    
endmodule