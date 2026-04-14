module divide_by_8 (
    input wire clk,
    input wire reset,
    input wire [2:0] in,
    output reg out
);
    reg [2:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 0;
            state <= 0;
        end else begin
            state <= in;
            if (state == 3'b000) begin
                out <= 1;  // 0 is divisible by 8
            end else begin
                out <= 0;  // 1 to 7 are not divisible by 8
            end
        end
    end
endmodule