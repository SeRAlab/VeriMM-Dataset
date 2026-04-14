module johnson_counter_3bit
(
    input clk,
    input rst,
    output reg [2:0] count
);

always @(posedge clk) begin
    if (rst)
        count <= 3'b000;
    else
        count <= {count[1:0], ~count[2]};
end

endmodule