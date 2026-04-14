module clock_gated_counter (
    input clk,
    input rst,
    input enable,
    input clk_gate,
    output reg [3:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000;
        end else if (enable && clk_gate) begin
            count <= count + 1;
        end
    end
endmodule