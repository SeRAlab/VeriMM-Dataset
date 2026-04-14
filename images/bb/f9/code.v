module counter4bit_down (
    input wire clk,
    input wire rst,
    output reg [3:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 4'b1111;
        else
            q <= q - 1;
    end

endmodule