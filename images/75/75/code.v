module odd_counter (
    input clk,
    input reset,
    output reg [3:0] count);always @(posedge clk or posedge reset) begin
        if (reset) count <= 4'b0001;
        else count <= (count == 4'b1111) ? 4'b0001 : count + 2;
    end

endmodule