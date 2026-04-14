module timer16(
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [15:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 16'b0;
        end else if (enable) begin
            count <= count + 1;
        end
    end

endmodule