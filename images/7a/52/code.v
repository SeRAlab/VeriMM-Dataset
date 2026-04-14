module top_module(
    input rst,
    input clk,
    input [2:0] compare,
    output pwm
);reg [2:0] counter;
    assign pwm = (counter < compare) ? 1'b1 : 1'b0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule