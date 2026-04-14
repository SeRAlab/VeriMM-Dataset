module up_down_counter_3bit (q, clk, reset, up_down);
   input clk, reset, up_down;
   output [2:0] q;
   
   reg [2:0] q;

always @(posedge clk or posedge reset) begin
    if (reset)
    begin
        q <= 3'b000;
    end
    else
    begin
        if (up_down)
            q <= q + 1;
        else
            q <= q - 1;
    end
end //End of always block
    
endmodule