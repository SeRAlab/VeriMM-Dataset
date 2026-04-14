module small_up_counter
(
    input clk,
    input en,
    input areset,
    output reg [2:0] count
);always @(posedge clk or posedge areset)
    if (areset) begin
        count <= 3'b0;
    end else if (en) begin
        count <= count + 1;
    end
endmodule