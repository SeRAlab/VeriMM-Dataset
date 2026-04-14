module top_module(
    input clk,
    input reset,
    output reg [3:0] out
);always @(posedge clk or negedge reset) begin
    if(!reset) begin
        out <= 4'b0000;
    end
    else begin
        out <= out + 1;
    end
end

endmodule