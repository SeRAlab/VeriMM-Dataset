module verified_up_down_counter(clk, up_down, count);

    input clk;
    input up_down;
    output reg [2:0] count;
    initial count = 0;

    always @(posedge clk)
        begin
            if (up_down)
                count <= count + 1;
            else
                count <= count - 1;
        end  

endmodule