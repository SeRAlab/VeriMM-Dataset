module reg_8bit(clk, clr, load, d, q);

    input clk;
    input clr;
    input load;
    input [7:0] d;
    output [7:0] q;
    reg [7:0] q;

    always @(posedge clk)
    begin
        if (clr)
            q <= 8'b00000000;
        else if (load)
            q <= d;
    end

endmodule