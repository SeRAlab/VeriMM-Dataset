module shift_register(
    input [7:0] data,
    input load,
    input shift,
    input clk,
    input rst,

    output reg [7:0] q
);

always @(posedge clk or posedge rst)
begin
    if (rst)
        q <= 8'b0; // reset register
    else if (load)
        q <= data; // load data into register
    else if (shift)
        q <= {1'b0, q[7:1]}; // shift right
end

endmodule