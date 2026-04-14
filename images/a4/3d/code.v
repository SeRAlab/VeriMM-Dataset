module UpDownCounter (
    input clk,
    input rst_n,
    input en,
    input up_down,
    output reg [2:0] count
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'b000;
        else if (en) begin
            if (up_down)
                count <= count + 1;
            else
                count <= count - 1;
        end
    end
endmodule