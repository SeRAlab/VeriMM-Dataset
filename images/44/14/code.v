module up_counter(
    input               clk     ,   
    input               arstn   ,

    output reg  [3:0]   count
);

always@(posedge clk or negedge arstn)
begin
    if(!arstn)  count <= 4'b0000;
    else        count <= count + 1;
end

endmodule