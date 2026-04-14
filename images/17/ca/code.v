module Timer (
    input clk,
    input reset,
    output reg [15:0] count,
    output reg max_limit
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 16'b0;
            max_limit <= 1'b0;
        end else begin
            if (count == 16'hFFFF) begin
                count <= 16'b0;
                max_limit <= 1'b1;
            end else begin
                count <= count + 1;
                max_limit <= 1'b0;
            end
        end
    end
endmodule