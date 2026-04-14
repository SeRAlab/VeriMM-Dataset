module timer (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [15:0] limit,
    output reg limit_reached
);
    reg [15:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 16'b0;
            limit_reached <= 1'b0;
        end else if (enable) begin
            if (count < limit) begin
                count <= count + 1;
                limit_reached <= 1'b0;
            end else begin
                limit_reached <= 1'b1;
            end
        end
    end
endmodule