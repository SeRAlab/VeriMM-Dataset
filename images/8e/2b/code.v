module shift_register(
    input clk,
    input rst,
    input left,
    input right,
    output reg [7:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 8'd0;
    end else if (left && !right) begin
        q <= q << 1;
    end else if (right && !left) begin
        q <= q >> 1;
    end
end

endmodule