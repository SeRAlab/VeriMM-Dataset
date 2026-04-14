module UpDownCounter (
    input clk,
    input reset,
    input up_down,
    output reg [2:0] count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 3'd0;
    end else if (up_down) begin
        count <= count + 1;
    end else begin
        count <= count - 1;
    end
end

endmodule