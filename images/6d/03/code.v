module up_down_counter_3bit (
    input wire clk,
    input wire rst,
    input wire dir,
    output reg [2:0] count
    );

always @(posedge clk) begin
    if (rst) begin
        count <= 3'b000;
    end else if (dir) begin
        count <= count + 1;
    end else begin
        count <= count - 1;
    end
end

endmodule