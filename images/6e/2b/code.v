module bin_counter (
    input clk,
    input reset,
    input enable,
    input dir,
    output reg [3:0] count);

    always @(posedge clk) begin
        if (reset) count <= 4'b0000;
        else if (enable) count <= dir ? count + 1 : count - 1;
    end
endmodule