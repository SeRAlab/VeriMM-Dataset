module divide_by_4 (
    input wire clk,
    input wire reset,
    output reg [1:0] out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 2'b00;
        end else begin
            out <= out + 1'b1;
        end
    end
endmodule