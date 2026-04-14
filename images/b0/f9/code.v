module sync_counter(
    input clk,
    input rst,
    input en,

    output reg [15:0] count
);

always@(posedge clk or posedge rst)
begin
    if(rst)
        count <= 0;
    else if(en)
        count <= count + 1;
end

endmodule