module counter_16bit (
    input wire clk,
    input wire rst,
    output reg [15:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 16'b0;
        end else begin
            count <= count + 1;
        end
    end
endmodule