module binary_counter (
    input clk,
    input sreset,
    input en,
    output reg [3:0] count);

    always @(posedge clk) begin
        if (sreset) begin
            count <= 4'b0000;
        end else if (en) begin
            count <= count + 1;
        end
    end
endmodule