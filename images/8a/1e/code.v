module up_down_counter_8bit(
    input clk,
    input reset,
    input mode,
    output reg [7:0] count
);
    always @(posedge clk) begin
        if (reset)
            count <= 8'b00000000;
        else if (mode)
            count <= count + 1;
        else
            count <= count - 1;
    end
endmodule