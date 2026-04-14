module timer (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [15:0] limit,
    output reg [15:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 16'b0;
    end else if (enable) begin
        if (count < limit) begin
            count <= count + 1;
        end else begin
            count <= 16'b0; // Wrap around
        end
    end
end

endmodule