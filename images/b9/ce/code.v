module counter3bit_updown (
    input clk,
    input rst,
    input en,
    input up_down,
    output [2:0] count
);

    reg [2:0] count_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            count_reg <= 3'b000;
        else if (en) begin
            if (up_down)
                count_reg <= count_reg + 1;
            else
                count_reg <= count_reg - 1;
        end
    end

    assign count = count_reg;

endmodule