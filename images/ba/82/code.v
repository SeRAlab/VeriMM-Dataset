module counter3bit (
    input clk,
    input clear,
    output reg [2:0] count
);always @(posedge clk) begin
    if (clear) begin
        count <= 3'b0;
    end else begin
        count <= count + 1;
    end
end

endmodule