module up_down_counter_8bit(clk, reset, up_down, count);

    input  clk;  
    input  reset;  
    input  up_down;
    output  [7:0] count;
    reg   [7:0] count;
    initial count = 0;

    always @(posedge clk or posedge reset)
          begin
            if (reset)
                count <= 0;
            else if (up_down)
                count <= count + 1;
            else
                count <= count - 1;
          end  

endmodule