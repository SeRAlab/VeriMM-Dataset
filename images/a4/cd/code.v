module up_counter (
    input clk,
    input en,
    input reset,
    output reg [2:0] count);
always @(posedge clk or posedge reset)
begin
    if (reset)
        count <= 3'b000;
    else if (en)
        count <= count + 1;
end
endmodule