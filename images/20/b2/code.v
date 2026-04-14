module timer (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [15:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 16'b0;
    end else if (enable) begin
        if (count < 16'b1111111111111111) begin
            count <= count + 1;
        end else begin
            count <= 16'b0; // reset to 0 after reaching maximum value
        end
    end
end

endmodule