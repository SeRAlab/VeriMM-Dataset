module up_down_counter (
    input clk,
    input reset,
    input mode,
    output reg [3:0] count);always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0;
    end else begin
        if (mode) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
end
endmodule