module up_down_counter#(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire up,
    input wire down,
    output reg [WIDTH-1:0] count
);

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        count <= 0;
    end else if (en) begin
        if (up && !down) begin
            count <= count + 1;
        end else if (!up && down) begin
            count <= count - 1;
        end
    end
end

endmodule