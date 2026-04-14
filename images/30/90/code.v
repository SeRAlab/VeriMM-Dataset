module timer(
    input wire clk,
    input wire reset,
    input wire [15:0] target,
    output reg [15:0] count,
    output reg done
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 16'b0;
            done <= 1'b0;
        end else if (count < target) begin
            count <= count + 1;
            done <= 1'b0;
        end else begin
            done <= 1'b1;
        end
    end
endmodule