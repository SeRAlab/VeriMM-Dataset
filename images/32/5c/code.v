module timer (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [7:0] count,
    output reg max_reached
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 8'b0;
            max_reached <= 1'b0;
        end else if (enable) begin
            if (count == 8'd255) begin
                max_reached <= 1'b1;
            end else begin
                count <= count + 1;
                max_reached <= 1'b0;
            end
        end
    end
endmodule