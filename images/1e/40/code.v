module UpDownCounter (
    input wire clk,
    input wire reset,
    input wire up_down, // 1 for up count, 0 for down count
    output reg [3:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 4'b0000;
    end else if (up_down) begin
        count <= count + 1;
    end else begin
        count <= count - 1;
    end
end

endmodule