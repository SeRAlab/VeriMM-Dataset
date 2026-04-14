module shift_register(
    input wire clk,
    input wire rst,
    input wire d,
    output reg [7:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 8'b00000000;
    end else begin
        q <= {q[6:0], d};
    end
end

endmodule