module up_down_counter (
    input clk,
    input enable,
    input reset,
    input up_down,
    output reg [2:0] count
);

    always @(posedge clk) begin
        if (reset)
            count <= 3'b000;
        else if (enable) begin
            if (up_down)
                count <= count + 1;
            else
                count <= count - 1;
        end
    end

endmodule