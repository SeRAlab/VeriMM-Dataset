module up_down_counter_4bit (count, clk, reset, en, dir);
   input clk, reset, en, dir;
   output [3:0] count;
   
   reg [3:0] count;

always @(posedge clk or posedge reset) begin
    if (reset)
        count <= 4'b0000;
    else if (en) begin
        if (dir)
            count <= count + 1;
        else
            count <= count - 1;
    end
end

endmodule