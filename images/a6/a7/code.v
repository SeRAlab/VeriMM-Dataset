module binary_down_counter (
    input clk,
    input reset,
    output reg [2:0] count
);always @(posedge clk) begin
        if (reset)
            count <= 3'b111;
        else
            count <= count - 1;
    end

endmodule