module sync_counter(
    input clk,
    input rst,
    input en,
    
    output reg [7:0] q
);

always @(posedge clk)
begin
    if (rst)
        q <= 8'b0;
    else if (en)
        q <= q + 1;
end

endmodule