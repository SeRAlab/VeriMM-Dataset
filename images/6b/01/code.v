module binary_counter(
    input clk,
    input reset,
    output reg [3:0] count,
    output reg carry_out);always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0;
        carry_out <= 1'b0;
    end
    else if (count == 4'b1111) begin
        count <= 4'b0;
        carry_out <= 1'b1;
    end
    else begin
        count <= count + 1;
        carry_out <= 1'b0;
    end
end
endmodule