module freq_div_by_4(
    input wire clk,
    input wire rst,
    output reg clk_out
);

reg [1:0] count;

always @(posedge clk) begin
    if (rst) begin
        count <= 2'b00;
        clk_out <= 0;
    end else begin
        count <= count + 1;
        if (count == 2'b11) begin
            clk_out <= ~clk_out;
        end
    end
end

endmodule