module UpDownCounter #(parameter N = 4) (
    input wire clk,
    input wire reset,
    input wire up_down, // 1 for up, 0 for down
    output reg [N-1:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
        end else begin
            if (up_down) begin
                count <= count + 1; // Count up
            end else begin
                count <= count - 1; // Count down
            end
        end
    end
endmodule