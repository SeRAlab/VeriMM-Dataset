module up_down_counter(
    input wire clk,
    input wire reset,
    input wire up,
    input wire down,
    input wire enable,
    output reg [3:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000;
        end else if (enable) begin
            if (up && !down) begin
                count <= count + 1;
            end else if (down && !up) begin
                count <= count - 1;
            end
        end
    end
endmodule