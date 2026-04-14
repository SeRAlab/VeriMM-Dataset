module top_module (
    input wire clk,
    input wire rst,
    input wire up,
    input wire down,
    output reg [2:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 3'b000;
        else if (up)
            count <= count + 1;
        else if (down)
            count <= count - 1;
    end

endmodule