module up_counter (
    input clk,
    input reset,
    input enable,
    output reg [31:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 32'b0;
        end else if (enable) begin
            count <= count + 1'b1;
        end
    end
endmodule