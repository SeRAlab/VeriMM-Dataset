module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [3:0] count_out
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            count_out <= 4'd0;
        else if (up_down)
            count_out <= count_out + 1; // Increment
        else
            count_out <= count_out - 1; // Decrement
    end
endmodule