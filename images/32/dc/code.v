module timer_16bit (
    input clk,
    input reset,
    input enable,
    output reg [15:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 16'h0000;
        end else if (enable) begin
            count <= (count == 16'hFFFF) ? 16'h0000 : count + 1;
        end
    end
endmodule