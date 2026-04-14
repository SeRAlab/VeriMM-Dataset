module counter (
    input clk,
    input reset,
    input en,
    output reg [7:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 8'b0;
        end else if (en) begin
            count <= count + 1;
        end
    end

endmodule