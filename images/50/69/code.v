module top_module(
    input clk,
    input rst,
    output reg [3:0] count
);always @(posedge clk) begin
    if (rst) begin
        count <= 4'b0000; // reset the counter to 0
    end else begin
        count <= count + 1; // increment the counter
    end
end

endmodule