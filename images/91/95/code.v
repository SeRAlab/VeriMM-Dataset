module down_counter_10bit (
    input clk,
    input areset,
    input en,
    output reg [9:0] count);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            count <= 10'b1111111111;
        end else if (en) begin
            count <= count - 1;
        end
    end
endmodule