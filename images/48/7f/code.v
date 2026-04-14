module up_down_counter (
    input clk,
    input up,
    input down,
    output reg [3:0] count
);

    always @(posedge clk) begin
        if (up)
            count <= count + 1;
        else if (down)
            count <= count - 1;
    end

endmodule