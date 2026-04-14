module up_counter(
    input wire clk,
    input wire rst,
    output reg [3:0] count
);

always @(posedge clk) begin
    if (rst) begin
        count <= 4'd0;
    end else begin
        count <= count + 4'd1;
    end
end

endmodule