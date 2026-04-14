module up_counter_4bit(
    input clk,
    input en,
    input rst,
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (rst) begin
            count <= 4'b0000;
        end else if (en) begin
            count <= count + 1;
        end
    end
endmodule