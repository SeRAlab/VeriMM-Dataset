module timer_8bit (
    input clk,
    input reset,
    input enable,
    output reg [7:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 8'b00000000;
        end else if (enable) begin
            if (count < 8'b11111111) begin
                count <= count + 1;
            end
        end
    end
endmodule