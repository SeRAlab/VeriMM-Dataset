module binary_counter_by_2 (
    input clk,
    input rst,
    input en,
    output reg [5:0] count);

    always @(posedge clk) begin
        if (rst) begin
            count <= 6'b0;
        end else if (en) begin
            count <= count + 2;
        end
    end
endmodule