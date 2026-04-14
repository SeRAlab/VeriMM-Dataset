module top_module(
    input clk,
    input rst,
    input up_down,
    output reg [3:0] count
);always @ (posedge clk or posedge rst) begin
    if (rst) begin
        count <= 4'b0;
    end else if (up_down) begin
        if (count == 4'b1111) begin
            count <= 4'b0;
        end else begin
            count <= count + 1;
        end
    end else begin
        if (count == 4'b0000) begin
            count <= 4'b1111;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule