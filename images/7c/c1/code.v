module johnson_counter (
    input clk,
    input areset,
    input en,
    output reg [5:0] count);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            count <= 6'b000000;
        end else if (en) begin
            count <= {~count[5], count[5:1]};
        end
    end
endmodule