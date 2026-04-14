module binary_counter (
    input clk,
    input rst,
    input en,
    output reg [1:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 2'b00;
        end else if (en) begin
            count <= count + 1;
        end
    end
endmodule