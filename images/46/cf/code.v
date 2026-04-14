module johnson_counter_8bit
(
    input clk,
    input rst,
    output reg [7:0] count
);

always @(posedge clk) begin
    if (rst) begin
        count <= 8'b00000000;
    end else begin
        count <= {count[6:0], ~count[7]};
    end
end

endmodule