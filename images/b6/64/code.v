module shift_register(clk, rst, load, parallel_in, q);

    input  clk;
    input  rst;
    input  load;
    input  [7:0] parallel_in;
    output reg [7:0] q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 8'b0;
        else if (load)
            q <= parallel_in;
        else
            q <= {q[6:0], 1'b0};
    end
    
endmodule