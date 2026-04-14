module top_module(
    input clk,
    input reset,
    input enable,
    input control,
    output reg [3:0] count
);always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0;
    end else if (enable) begin
        if (control) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule