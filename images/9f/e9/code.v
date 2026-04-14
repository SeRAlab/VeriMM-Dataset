module up_down_counter_3bit (
    input clk,
    input reset,
    input up,
    input down,
    output reg [2:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 0;
        else if (up && !down)
            count <= count + 1;
        else if (!up && down)
            count <= count - 1;
    end

endmodule