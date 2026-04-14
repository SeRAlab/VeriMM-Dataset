module up_counter(
    input clk,
    input reset,
    input enable,
    output reg [2:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 3'd0;
        else if (enable)
            count <= count + 1;
    end
endmodule