module counter_64bit (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [63:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 64'b0;
        end else if (enable) begin
            count <= count + 1;
        end
    end
endmodule