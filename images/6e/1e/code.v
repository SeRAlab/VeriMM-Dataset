module bidirectional_counter(
    input clk,
    input reset,
    input enable,
    input direction,
    output reg [15:0] count);

always @(posedge clk) begin
    if (reset)
        count <= 16'hFFFF;
    else if (enable) begin
        if (direction)
            count <= count + 1;
        else
            count <= count - 1;
    end
end
endmodule