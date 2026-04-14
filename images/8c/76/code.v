module binary_counter (
    input clk,
    input reset_n,
    input enable,
    output reg [3:0] count
);always @(posedge clk) begin
    if (~reset_n) begin
        count <= 4'b0000;
    end else if (enable) begin
        count <= count + 1;
    end
end

endmodule