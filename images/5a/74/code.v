module UpDownCounter (
    input clk,
    input reset,
    input up,
    input down,
    output reg [3:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 4'b0000;
        else if (up)
            count <= count + 1;
        else if (down)
            count <= count - 1;
    end
endmodule