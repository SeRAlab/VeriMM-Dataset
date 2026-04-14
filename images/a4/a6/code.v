module up_counter(
    input           clk   ,
    input           rst   ,
    input           en    ,

    output reg [3:0] count
);

always @(posedge clk)
begin
    if (rst)
        count <= 4'b0000;
    else if (en)
        count <= count + 1;
end

endmodule