module load_register(clk, rst, load, d, q);

    input clk;
    input rst;
    input load;
    input [7:0] d;
    output [7:0] q;
    reg [7:0] q;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
            q <= 8'b00000000;
        else if (load)
            q <= d;
    end

endmodule