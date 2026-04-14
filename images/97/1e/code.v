module johnson_counter_8bit (
    input clk,
    input rst,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 8'b00000000;
    end else begin
        q <= {~q[0], q[7:1]};
    end
end

endmodule