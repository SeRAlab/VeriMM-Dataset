module register(
    input clk,
    input rst,
    input load,
    input [7:0] data,

    output reg [7:0] q
);

always @(posedge clk or posedge rst)
begin
    if (rst)
        q <= 8'b00000000;   // reset
    else if (load)
        q <= data;          // load
end

endmodule