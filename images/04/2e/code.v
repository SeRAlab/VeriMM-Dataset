module timer (
    input clk,
    input reset,
    input [31:0] max_count,
    output reg [31:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 32'b0;
        end else begin
            if (count < max_count) begin
                count <= count + 1'b1;
            end else begin
                count <= 32'b0;
            end
        end
    end
endmodule