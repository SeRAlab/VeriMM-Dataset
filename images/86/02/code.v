module johnson_counter(
    input clk,
    input rst,
    output reg [7:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 8'd0;
    end else begin
        q <= {~q[0], q[7:1]};
    end
end

endmodule