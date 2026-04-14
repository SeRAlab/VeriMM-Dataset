module shift_register(
    input wire clk,
    input wire rst,
    input wire load,
    input wire [3:0] data_in,
    input wire shift_left,
    input wire shift_right,
    output reg [3:0] q
    );

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 4'b0000;
    else if (load)
        q <= data_in;
    else if (shift_left)
        q <= {q[2:0], 1'b0};
    else if (shift_right)
        q <= {1'b0, q[3:1]};
end

endmodule