module up_down_counter(
    input wire clk,
    input wire rst,
    input wire en,
    input wire dir,
    output reg [3:0] count
);

always @(posedge clk) begin
    if (rst) begin
        count <= 4'b0000;
    end else if (en) begin
        if (dir) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule