module timer_8bit (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [7:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 8'b00000000;
        end else if (enable) begin
            count <= (count == 8'b11111111) ? 8'b00000000 : count + 1;
        end
    end
endmodule