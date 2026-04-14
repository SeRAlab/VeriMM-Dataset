module up_down_counter_4bit
    (
        input clk,
        input rst,
        input up_down,
        output reg [3:0] count
    );

    always @(posedge clk or posedge rst)
    begin
        if (rst)
            count <= 4'b0000;
        else if (up_down)
            count <= count + 1;
        else
            count <= count - 1;
    end

endmodule