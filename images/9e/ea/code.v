module shift_register_4bit (
    input wire d,
    input wire clk,
    input wire rst,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (rst)
        q <= 4'b0000;
    else
        q <= {q[2:0], d};
end

endmodule