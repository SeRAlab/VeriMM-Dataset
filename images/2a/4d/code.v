module divide_by_8 (
    input clk,
    input rst,
    output reg out
);
    reg [2:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 3'b000;
            out <= 1'b0;
        end else begin
            count <= count + 1;
            if (count == 3'b111) begin
                out <= ~out; // Toggle output every 8 clock cycles
            end
        end
    end
endmodule