module up_counter (
    input clk,
    input reset_n,
    input enable,
    output reg [2:0] count
);always @(posedge clk) begin
    if (!reset_n) begin
        count <= 3'b000;
    end else if (enable) begin
        count <= count + 1;
    end
end

endmodule