module timer (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [7:0] threshold,
    output reg [7:0] count,
    output reg threshold_reached
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 8'b0;
            threshold_reached <= 1'b0;
        end else begin
            if (enable) begin
                count <= count + 1;
                if (count == threshold) begin
                    threshold_reached <= 1'b1;
                end else begin
                    threshold_reached <= 1'b0;
                end
            end
        end
    end
endmodule