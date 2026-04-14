module up_down_counter#(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire up,
    output wire [WIDTH-1:0] count
);

reg [WIDTH-1:0] counter;

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        counter <= 0;
    end else if (en) begin
        if (up) begin
            counter <= counter + 1;
        end else begin
            counter <= counter - 1;
        end
    end
end

assign count = counter;

endmodule