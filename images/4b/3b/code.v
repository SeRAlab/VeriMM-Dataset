module up_down_counter(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire up_down,
    output reg [7:0] count
    );

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 8'd0;
    end else if (enable) begin
        if (up_down) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule