module up_down_counter_4bit(
    input wire clk,
    input wire en,
    input wire rst,
    input wire dir,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 4'b0000;
    end else if (en) begin
        if (dir) begin
            q <= q + 1;
        end else begin
            q <= q - 1;
        end
    end
end

endmodule