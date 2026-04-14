module UpDownCounter4 (
    input clk,
    input rst,
    input en,
    input up_down,
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (rst)
            count <= 4'b0;
        else if (en) begin
            if (up_down)
                count <= count + 1;
            else
                count <= count - 1;
        end
    end
endmodule