module up_counter (
    input clk,
    input areset,
    input en,
    output reg [2:0] count);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            count <= 3'b000;
        end else if (en) begin
            count <= count + 1;
        end
    end
endmodule