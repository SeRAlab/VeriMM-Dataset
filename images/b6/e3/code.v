module counter (
    input clk,
    input reset,
    output reg [7:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 8'b00000000;
        end else begin
            count <= count + 1;
        end
    end
endmodule