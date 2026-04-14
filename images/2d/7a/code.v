module counter_16bit (
    input clk,
    input rst_n,
    input en,
    output reg [15:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 16'b0;
        end else if (en) begin
            count <= count + 1;
        end
    end
endmodule