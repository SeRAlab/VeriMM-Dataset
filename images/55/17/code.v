module binary_counter (
    input clk,
    input enable,
    input reset,
    output reg [3:0] count);always @(posedge clk or posedge reset) begin
        if (reset) count <= 0;
        else if (enable) count <= count + 1;
    end

endmodule