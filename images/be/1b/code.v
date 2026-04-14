module up_down_counter(
    input wire clk,
    input wire rst,
    input wire enable,
    input wire up_down,
    output reg [3:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000;
        end
        else if (enable) begin
            if (up_down) begin
                count <= count + 4'b0001;
            end
            else begin
                count <= count - 4'b0001;
            end
        end
    end
endmodule