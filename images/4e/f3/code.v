module counter(
    input clk,
    input rst,
    input up_down,

    output reg [3:0] count
);

always @(posedge clk or posedge rst)
begin
    if (rst)
        count <= 4'b0; // reset count to 0
    else if (up_down)
        count <= count + 1; // count up
    else
        count <= count - 1; // count down
end

endmodule