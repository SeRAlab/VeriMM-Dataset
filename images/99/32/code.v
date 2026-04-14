module register(
    input clk,
    input reset,
    input ena,
    input [7:0] data,
    output reg [7:0] q);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 0;
        end else if (ena) begin
            q <= data;
        end
    end

endmodule