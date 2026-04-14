module counter_3bit_updown (
    input wire clk,
    input wire rst,
    input wire en,
    input wire up,
    output reg [2:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 3'b000;
        else if (en) begin
            if (up)
                count <= count + 1;
            else
                count <= count - 1;
        end
    end

endmodule