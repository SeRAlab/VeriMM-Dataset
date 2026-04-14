module divide_by_4(
    input clk,
    input [1:0] in,
    output reg out
);
    reg [1:0] state;

    always @(posedge clk) begin
        state <= in;
        if (state == 2'b00) begin
            out <= 0;
        end else if (state == 2'b01) begin
            out <= 0;
        end else if (state == 2'b10) begin
            out <= 0;
        end else if (state == 2'b11) begin
            out <= 1;
        end
    end
endmodule