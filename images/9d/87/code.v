module binary_counter_sync_reset(
    input clk,
    input rst,
    output reg [1:0] count
);

always @(posedge clk) begin
    if (rst) begin
        count <= 2'd0;
    end else begin
        count <= count + 1;
    end
end

endmodule