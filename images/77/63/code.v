module shift_reg3bit (
    input wire clk,
    input wire rstn,
    input wire d,
    output reg [2:0] q
);

always @(posedge clk or negedge rstn)
begin
    if (~rstn)
        q <= 3'b000;
    else
        q <= {q[1:0], d};
end

endmodule