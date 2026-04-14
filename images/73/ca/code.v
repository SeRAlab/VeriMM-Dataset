module down_counter(
    input wire clk,
    input wire rst_n,
    input wire enable,
    output reg [7:0] count
    );

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 8'd255;
    else if (enable)
        count <= count - 1'b1;
end

endmodule