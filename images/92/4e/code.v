module counter_4bit (
        input clk,
        input rst,
        input enable,
        output reg [3:0] count,
        output reg max_reached);

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 4'b0000;
        else if (enable)
            count <= count + 1'b1;
    end

    always @(posedge clk) begin
        if (count == 4'b1111)
            max_reached <= 1'b1;
        else
            max_reached <= 1'b0;
    end

endmodule