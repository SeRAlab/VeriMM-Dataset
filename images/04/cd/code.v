module counter_64bit (
    input wire clk,
    input wire rst_n,
    output reg [63:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 64'b0;
        end else begin
            count <= count + 1'b1;
        end
    end
endmodule