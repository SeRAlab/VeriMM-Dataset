module decade_counter (
    input clk,
    input reset,
    output reg [3:0] count);always @(posedge clk or posedge reset) begin
        if (reset) count <= 4'b0000;
        else count <= (count == 4'b1001) ? 4'b0000 : count + 1;
    end

endmodule