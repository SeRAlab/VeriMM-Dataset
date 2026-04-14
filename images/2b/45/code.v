module timer (
    input wire clk,
    input wire rst,
    output reg [31:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 32'b0;
        end else begin
            if (count == 32'hFFFFFFFF) begin
                count <= 32'b0;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule