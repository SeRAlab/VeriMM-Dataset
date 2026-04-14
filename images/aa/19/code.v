module up_down_counter_2bit (clk, reset, up, down, count);
   input clk, reset, up, down;
   output reg [1:0] count;

always @(posedge clk) begin
    if (reset)
        count <= 2'b00;
    else if (up)
        count <= count + 1;
    else if (down)
        count <= count - 1;
end

endmodule