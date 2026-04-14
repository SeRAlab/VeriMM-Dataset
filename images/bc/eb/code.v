module shift_register(
    input clk,
    input rst,
    input load,
    input shift,
    input [6:0] data,

    output reg [6:0] q
);

always @(posedge clk or posedge rst)
begin
    if (rst)
        q <= 7'b0000000;        // reset
    else if (load)
        q <= data;              // load
    else if (shift)
        q <= {q[5:0], 1'b0};    // shift left
end

endmodule