module sync_counter #(parameter WIDTH = 4) (
    input clk,
    input rst,
    input en,
    output reg [WIDTH-1:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
    end else if (en) begin
        count <= count + 1;
    end
end

endmodule