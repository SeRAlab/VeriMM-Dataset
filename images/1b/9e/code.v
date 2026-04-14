module timer (
    input clk,
    input reset,
    input enable,
    output reg [7:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 8'd0;
    end else if (enable) begin
        if (count < 8'd255) begin
            count <= count + 1;
        end else begin
            count <= 8'd0;
        end
    end
end

endmodule