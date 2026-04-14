module modulo5_counter (
    input clk,
    input reset,
    output reg [2:0] count);always @(posedge clk or posedge reset) begin
        if (reset) count <= 3'b000;
        else count <= (count == 3'b100) ? 3'b000 : count + 1;
    end

endmodule