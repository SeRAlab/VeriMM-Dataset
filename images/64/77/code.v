module counter_8bit(clk, rst, enable, up, down, count);
    input clk, rst, enable, up, down;
    output reg [7:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 8'b0;
        else if (enable) begin
            if (up && !down)
                count <= count + 1;
            else if (!up && down)
                count <= count - 1;
        end
    end
endmodule