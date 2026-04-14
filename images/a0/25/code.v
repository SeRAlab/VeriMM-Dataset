module counter_4bit(
    input wire clk,
    input wire rst,
    input wire en,
    input wire direction,
    output reg [3:0] count
    );

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 4'b0000;
    end
    else if (en) begin
        if (direction) begin
            count <= count + 1;
        end
        else begin
            count <= count - 1;
        end
    end
end

endmodule